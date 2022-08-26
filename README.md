# README

Project still under construction

Non-Rails Stuff
	Main non-rails files are currently living in app/models:
		- data_structures.rb
		- helper_functions.rb
		- segmentor.rb
		- tokenizer.rb
		- util.rb

	The goal of the app is to separate a text into words so that the word list can be easily turned into flashcards or used to very roughly estimate the overall difficulty of the text. 

	There are two algoithms I'm using for separating the text, full segmentation and tokenization

		- Full Segmentation: 
			- Each index of the input text is used as a starting point and the longest word with that starting point that appears in the word list is added to the output IF it "pushes passed" the current right most index reached by any previous words that have started at earlier indices. For example, assume 小红帽 and 红帽 are both in the word list, if 小红帽 is found, then on the next iteration, 红帽 would not be added because they end on the same index in the input text. 
			- if a character does not match any words in the word list it is added to a running list of unknown characters that is then added to the output once the next word is found. For example, if the input is "我是一个red的苹果", red will be pulled out as a single unknown word. I prefer this to completely removing it from the output or having the output contain 'r','e',and 'd', separately. 
			- There is a small list of stop words for this algorithm, such as the newline character that will automatically end the current segmentation. This was helpful for when strings of unknown characters contained the newline character and to make sure the lone newline character did not make it into the output. 

		- Tokenization ( I want to redo this algorithm, but this is how it works right now ):
			- This algorithm is meant to find repeated sequences of characters that do not appear in the dictionary. 
			- Starting at each index of the text, add any unique tokens found to the output that are less than or equal to the max token length, provided they are not dictionary words. 
			- Once all tokens are acquired, go through and remove any tokens that only exist as part of larger tokens with the same count. For example, if you have both {"大石头"， 5} and {"石头", 5} in the output, then 石头 will be removed because it only ever appears in the text as part of the longer string 大石头. Finally remove any tokens that are shorter than the minimum token lenth, and remove any tokens that appear less times than the minimum token count. Also, tokens that are also dictionary words are excluded. 
			- I feel this algorithm can be improved by not having to arbitrarily bound the max token length. For example if there is a token found of max length, it's possible that all occurances of that token are flanked by the same characters, but because I also wish to remove tokens that only appear as subsets of larger tokens, I still need to figure out how I want to accomplish this. 

	The result of the above processes both produce shingles, named so because it is possible for the resulting segments to overlap with one another in the input text. For example, if "ABCD" is the input and "ABC" and "BCD" are both words then this algorithm will return both of them as I am not attempting to make my program aware of chinese syntax and grammar. I could also use relative frequencies of "ABC" and "D" vs "A" and "BCD" to select the most likely match, but that would be extra work and I personally would prefer to get "ABC" and "BCD" in this situation anyway. 


Rails-Stuff
	- Devise for authentication
	- Can Can for roles - still working on it
	- chunky_png for generating random PNG icons for each input text
	- Datatables for displaying shingles nad input texts
	- Currently just using sqlite3 for db, plan to use postgresql
	- I would like to host on GCP because all my previous projects are on AWS and the whole point of this project is to learn new stuff. 

