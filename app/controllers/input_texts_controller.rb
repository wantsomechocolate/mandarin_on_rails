class InputTextsController < ApplicationController

	include HelperFunctions
	include DataStructures
	include Tokenizer
	include Segmentor
	include Util


	load_and_authorize_resource

	def index
		@input_texts = current_or_guest_user.input_texts
		if @input_texts.any?
			return @input_texts
		else
			flash.keep
			redirect_to "/input_texts/new" #, notice: "You don't have any input texts"
		end
	end


	def new
		@input_text = InputText.new
	end


	def show
		known_words = current_or_guest_user.known_words.pluck(:word)
		@input_text = InputText.find(params[:id])

		## Query for shingles that are part of the text, but that are not marked as known
		@shingles = @input_text.shingles.joins("LEFT JOIN known_words ON known_words.word = shingles.val AND known_words.user_id = "+current_or_guest_user.id.to_s).where('known_words.id' => nil)
	end


	def create
		#If I don't clear flash messages I set later in this method, they persist for one more page refresh or redirect than I want
		#If the form submit has errors. Because where there are errors, render is used instead of redirect 
		flash.clear 

		@input_text = InputText.new(input_text_params)
		@input_text['user_id'] = current_or_guest_user.id
		@input_text['title'] = "My Input Text - "+Time.now.utc.to_s

		## Add the icon
		png = randimg
		temp_file = Tempfile.new()
		png.save(temp_file)
		@input_text.avatar.attach(io:temp_file, filename:'avatar.png')

		## If I want to generate a flash message, I guess here would be a good time?
		if @input_text.body.length > 200 and current_or_guest_user.guest
			flash.alert = "Please create an account to process input texts longer than 200 characters"
		end

		if current_or_guest_user.input_texts.all.count >= 5 and current_or_guest_user.guest
			flash.alert = "Please create an account to have more than 5 input texts"
		end

		if @input_text.save

			#THIS IS WHERE I HAVE TO GENERATE THE TOKENS
			## There is a problem where I'm querying the database for the input_text id every time I create a shingle

			filepath = 'public/global_wordfreq.release_UTF-8.txt'
			trie,global_dict = build_trie_and_hash(filepath = filepath, num_lines = 100000)


			## This needs to be replaced with a call to the database. it should return all the words associated with this user
			## step one should just be printing them out on the page plain text style.
			user_dict = USERDICT #User Dictionary
			## This will also be a db table, but I have not worked on it yet
			comm_dict = COMMDICT #Community Dictionary
			## merge all the dicts together intelligently. 
			total_dict = comm_dict.merge(user_dict.merge(global_dict))

			## Get the text from the form and call the helper methods to actually get the shingles
			text = @input_text.body
			tokens = tokenize(text, stopwords = STOPWORDS_TK, word_dict = total_dict )
			words = longest_matching(text, word_trie = trie, stopwords = STOPWORDS_LM, config={} )
			## combine the words and tokens to get all the shingles
			shingles = tokens.merge(words)

			## Do some post processing on all the shingles to add hsk, frequency info, etc.
			## go through freq dict and hsk dict and update output list
			## Some of the stuff here is a workaround until I add
			## additional logic to the segmentation algo and the trie data structure

			hsk_file = 'public/hsklevels.csv'
			hsk_dict = build_hsk(hsk_file)

			## Even when I do this, it's still pinging the db for the id when it saves a shingle
			input_text_id = @input_text.id

			shingles.keys.each do |token|
				if total_dict.has_key?(token)
					if total_dict[token]['freq'].to_i == 0 
						shingles[token]['freq'] = -1
					else
						shingles[token]['freq'] = Math.log(total_dict[token]['freq'].to_i).round(2)
					end
				else
					shingles[token]['freq'] = -1
				end
				if hsk_dict.has_key?(token)
					shingles[token]['hsk_2012'] = hsk_dict[token]
				else
					shingles[token]['hsk_2012'] = -1
				end
				if comm_dict.has_key?(token)
					shingles[token]['shingle_type'] = 'community'
				end
				if user_dict.has_key?(token)
					shingles[token]['shingle_type'] = 'user'
				end
				shingles[token]['val'] = token
				shingles[token]['input_text_id'] = input_text_id

				temp = Shingle.create(shingles[token])
			end

			#############################################
			redirect_to @input_text
		else
			render :new, status: :unprocessable_entity
		end
	end


	def edit
		@input_text = InputText.find(params[:id])
	end


  def update
   	@input_text = InputText.find(params[:id])
    if @input_text.update(input_text_params)
     	redirect_to @input_text
   	else
   		render :edit, status: :unprocessable_entity
   	end
 	end


  def destroy
    @input_text = InputText.find(params[:id])
    @input_text.destroy
    redirect_to input_texts_path, status: :see_other
  end


	private
		def input_text_params
	  	params.require(:input_text).permit(:title, :body, :public, :hsk_2012, :shingle_count, :char_cnt, :avatar)
		end

end
