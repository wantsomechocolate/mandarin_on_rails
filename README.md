# README

## Hello!

Project still under construction but the goal of the app is to separate simplified Chinese text into words so that the word list can be easily turned into flashcards or used to very roughly estimate the overall difficulty of the text.


## Non-Rails Stuff
	
There are two algoithms I'm using for shingling the text, full segmentation and tokenization

### Full Segmentation: 
 - Each index of the input text is used as a starting point and the longest word with that starting point that appears in the word list is added to the output IF it "pushes passed" the current right most index reached by any previous words that have started at earlier indices. For example, assume 小红帽 and 红帽 are both in the word list, if 小红帽 is found, then on the next iteration, 红帽 would not be added because they end on the same index in the input text. But if 红帽 is encountered later on in the text without 小 in front of it, then it will also be added to the output.
 - If a character does not lead to any words in the word list it is added to a running list of unknown characters that is then added to the output once the next known word is found or the end of the text is reached. For example, if the input is "我是一个red的苹果", red will be pulled out as a single unknown word. I prefer this to completely removing it from the output or having the output contain 'r','e',and 'd', separately. 
 - There is a small list of default stop words for this algorithm (《》：，), that will automatically end the current segmentation. These will eventually be user configurable. 

### Tokenization: 
This algorithm is meant to find repeated sequences of characters that do not appear in the word list. I want to redo this algorithm, but this is how it works right now:
 - Starting at each index of the text, add any unique tokens found to the output that are less than or equal to the max token length, provided they are not in the word list. 
 - Once all tokens are acquired, go through and remove any tokens that only exist as part of larger tokens with the same count. For example, if you have both {"大石头"， 5} and {"石头", 5} in the output, then 石头 will be removed because it only ever appears in the text as part of the longer string 大石头. Finally remove any tokens that are shorter than the minimum token lenth, and remove any tokens that appear less times than the minimum token count. These parameters will also eventually be user configurable.

I feel this algorithm can be improved by not having to arbitrarily bound the max token length. For example if there is a token found of max length, it's possible that all occurances of that token are flanked by the same characters, but because I also wish to remove tokens that only appear as subsets of larger tokens, I still need to figure out how I want to accomplish this. 

### Result
The result of the above processes both produce shingles, named so because it is possible for the resulting segments to overlap with one another in the input text. It will also not return all actual words present in the text. Below is an example:

Say "大风车" is the input, this most likely is referring to a large (大） windmill (风车). But 大风 is actually a word in the word list that means "strong wind". Because 大风 is a word and this algorithm is always trying to find the longest match at every index, 大 will not be added to the output, instead, 大风 and 风车 will be added. Because they overlap with each other, they are referred to as shingles, which also overlap with each other. 

The files handling the above logic are currently living in app/models:
 - data_structures.rb
 - helper_functions.rb
 - segmentor.rb
 - tokenizer.rb
 - util.rb

## Rails-Stuff
 - Devise for authentication
 - Can Can for roles - still working on it
 - chunky_png for generating random PNG icons for each input text
 - Datatables for displaying shingles nad input texts
 - Currently just using sqlite3 for db, plan to use postgresql
 - I would like to host on GCP because all my previous projects are on AWS and the whole point of this project is to learn new stuff. 

## Thanks for Readmeing
