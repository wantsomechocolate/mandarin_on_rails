class TokensController < ApplicationController

	## Server side processing for DataTables ajax call

	include HelperFunctions
	include DataStructures
	include Tokenizer
	include Segmentor
	
	def update_token_table

		puts "I was called! and params were:", params
		
		filepath = 'public/global_wordfreq.release_UTF-8.txt'
		trie,global_dict = build_trie_and_hash(filepath = filepath, num_lines = 100000)
		user_dict = USERDICT #User Dictionary
		comm_dict = COMMDICT #Community Dictionary
		total_dict = comm_dict.merge(user_dict.merge(global_dict))
		text = params[:text]

		tokens = tokenize(text, stopwords = STOPWORDS_TK, word_dict = total_dict )
		words = longest_matching(text, word_trie = trie, stopwords = STOPWORDS_LM, config={} )

		tokens = tokens.merge(words)

		hsk_file = 'public/hsklevels.csv'
		hsk_dict = build_hsk(hsk_file)

		## go through freq dict and hsk dict and update output list
		tokens.keys.each do |token|
			if total_dict.has_key?(token)
				tokens[token]['freq']=Math.log(total_dict[token]['freq'].to_i).round(2)
			else
				tokens[token]['freq']="-"
			end

			if hsk_dict.has_key?(token)
				tokens[token]['hsk'] = hsk_dict[token]
			else
				tokens[token]['hsk'] = "-"
			end

		end

		data_table = []
		i=1
		tokens.keys.each do |token|
			tokens[token]['word'] = token
			tokens[token]['index'] = i

			## At some point I plan to add user dict and comm dict to the trie before segmentation
			## but this is a workaround for now
			if user_dict.has_key?(token)
				tokens[token]['shingle_type'] = 'user'
			elsif comm_dict.has_key?(token)
				tokens[token]['shingle_type'] = 'community'
			else
			end

			data_table.append(tokens[token])
			i+=1
		end
		
		render json: data_table

	end

end
