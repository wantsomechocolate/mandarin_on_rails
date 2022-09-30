class InputTextsController < ApplicationController

	include HelperFunctions
	include DataStructures
	include Tokenizer
	include Segmentor
	include Util


	load_and_authorize_resource

	def index
		
		@input_texts = current_or_guest_user.input_texts

		#flash.alert = "User not found."

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

		#puts known_words

		@input_text = InputText.find(params[:id])

		## Remove known shingles from the shingles list

		@shingles = @input_text.shingles.joins("LEFT JOIN known_words ON known_words.word = shingles.val").where('known_words.id' => nil)

		#puts "Hello!"
		#puts @shingles

		#filtered_shingles =  @input_text.shingles.select{|h| known_words.include?(h[:val]) == False}

		#puts filtered_shingles

	end


	def create
		#puts "I was called and params were:", input_text_params

		@input_text = InputText.new(input_text_params)

		@input_text['user_id'] = current_or_guest_user.id

		@input_text['title'] = "My Input Text - "+Time.now.utc.to_s

		## Add the icon
		png = randimg
		temp_file = Tempfile.new()
		png.save(temp_file)

		@input_text.avatar.attach(io:temp_file, filename:'avatar.png')


		if @input_text.save

			#THIS IS WHERE I HAVE TO GENERATE THE TOKENS

			filepath = 'public/global_wordfreq.release_UTF-8.txt'
			trie,global_dict = build_trie_and_hash(filepath = filepath, num_lines = 100000)


			## This needs to be replaced with a call to the database. it should return all the words associated with this user
			## step one should just be printing them out on the page plain text style.
			user_dict = USERDICT #User Dictionary



			comm_dict = COMMDICT #Community Dictionary
			total_dict = comm_dict.merge(user_dict.merge(global_dict))
			text = @input_text.body
			tokens = tokenize(text, stopwords = STOPWORDS_TK, word_dict = total_dict )
			words = longest_matching(text, word_trie = trie, stopwords = STOPWORDS_LM, config={} )

			shingles = tokens.merge(words)

			hsk_file = 'public/hsklevels.csv'
			hsk_dict = build_hsk(hsk_file)

			## go through freq dict and hsk dict and update output list
			## Most of the stuff here is a workaround until I add
			## additional logic to the segmentation algo and the trie data structure

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

				#puts shingles[token]

				temp = Shingle.create(shingles[token])
				#temp.save
			end

			#temp = Shingle.insert_all(shingles)
			#temp.save()

=begin
			shingles.each.keys do |shingle|

			shingle = Shingle.new({'input_text_id' => @input_text.id, 'val'=>"我", 'freq'=>"21"})
			shingle.save()

			shingle = Shingle.new({'input_text_id' => @input_text.id, 'val'=>"是", 'freq'=>"21"})
			shingle.save()
=end


			#############################################



			## this works by looking at the prefixes for the paths
			## we find article, which knows then to find the ID 
			## because its in the route definition
			redirect_to @input_text
			#redirect_to '/input_texts/19', :layout => "application"
			#redirect_to action: :show
			#redirect_to :action => show, :id => :params[:id]
			#render @input_text.id
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
