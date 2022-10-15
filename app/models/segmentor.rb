## THIS IS NOT A MODEL

module Segmentor

	## Loop through all characters in the input text
	## Find the longest word you can find in the dictionary for each starting character.
	## If the word you find increases your "high-point", add_or_increment it in the output. 
	## Also captures "unknown words", which are strings of characters that do not result in a dictionary entry
	## Uses a small set of stop characters

	def longest_matching(text, word_trie = {}, stopwords = {}, config={} )

		trie = word_trie
		stopwords_lm = stopwords

		output = {}
		i = 0
		unknown = ""
		right_max = 0
		stopwords_lm = stopwords

		while i<text.length
		    parent_node = trie
		    cur_string = ""
		    longest_word = ""
		    j = 0 #for traversing the tree
		    cur_char = text[i+j,1]

		    if stopwords_lm.include?(cur_char)
		        # Process Unknown
		        if unknown.length > 0
		            add_or_increment(output,unknown,'unknown')
		            unknown = ""
		        end

		    else
		        ## while the parent node continues to have the next character as a child
		        while parent_node.children.has_key?(cur_char)
		            cur_string += cur_char #does not mean you have found a word yet
		            ## If the node for the current character is a word then update longest word to equal the current string
		            if parent_node.children[cur_char].is_word
		                longest_word = cur_string
		            end

		            ## update parent node, increase j, and update cur_char for next round
		            parent_node = parent_node.children[cur_char]
		            j+=1
		            cur_char = text[i+j,1]
		        end

		        ## after this process, if the longest_word is empty it means whatever you found wasn't in the dictionary
		        ## If the unknown character doesn't push past right_max, then just move on
		        ## If it does, then add the character you started on (where i is) to unknown and continue on
		        if longest_word == "" 

		        	if i+1 > right_max
		            	unknown += text[i,1]
		            	right_max+=1
		            end
		        
		        ## You found a word!
		        else

		            ## Process unknown
		            if unknown.length > 0 #and unknown.split.join(" ")!=""
		                add_or_increment(output,unknown,'unknown')
		                unknown = ""
		            end
		            
		            ## Then add the word you found IF right > right_max 
		            ## (e.g. if you parse 中国 don't add 国 right after adding 中国, but if parsing 中国家 do add 中国 and 国家)
		            if i + longest_word.length > right_max
		                add_or_increment(output,longest_word,'dictionary')
		                right_max = i+longest_word.length
		            end    
		        end
		    end
		    i+=1
		end

		return output
	end

end