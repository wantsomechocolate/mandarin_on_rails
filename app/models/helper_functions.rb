#helper_functions.rb
require 'set'

module HelperFunctions

    USERDICT = {'小红帽'=>{'shingle_type'=>'user'},'灰狼'=>{'shingle_type'=>'user'}}
    COMMDICT = {
                    '每一次'=>{'shingle_type'=>'community','def' => 'every time'},
                    '一'=>{'shingle_type'=>'community','def' => 'one'},
                    '二'=>{'shingle_type'=>'community','def' => 'two'},
                    '三'=>{'shingle_type'=>'community','def' => 'three'},
                    '四'=>{'shingle_type'=>'community','def' => 'four'},
                    '五'=>{'shingle_type'=>'community','def' => 'five'},
                    '六'=>{'shingle_type'=>'community','def' => 'six'},
                    '七'=>{'shingle_type'=>'community','def' => 'seven'},
                    '八'=>{'shingle_type'=>'community','def' => 'eight'},
                    '九'=>{'shingle_type'=>'community','def' => 'nine'},
                    '十'=>{'shingle_type'=>'community','def' => 'ten'},
                    '多'=>{'shingle_type'=>'community','def' => 'a lot, how much, that much', 'hsk_2012'=>45563013},
                    '点'=>{'shingle_type'=>'community','def' => 'spot, point'},

                }



    STOPWORDS_LM = Set.new(['，','   》','《','：'])
    STOPWORDS_TK = Set.new(["（" , "）" , "〈" , "〉" , "《" , "》" , "［" , "］" , "｛" , "｝" , "｜" , "{" , "}" , "[" , "]" , "＜" , "＞" ,
                    ## Puncuation
                    "、" , "。" , "！" , "-" , "“" , "”" , "," , "." , ":" , "，" , "：" , "；" , "？" , "!" , "?" , "." ,
                    ## Numbers
                    "０" , "１" , "２" , "３" , "４" , "５" , "６" , "７" , "８" , "９" ,
                    "0" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" ,
                    ## English Letters
                    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                    ## Other
                    "\n" , " " , "＠" , "～" , "￥" , "＆" , "＊" , "＋" , "＃" , "＄" , "％" , "︿","/"])

    def add_or_increment(output,text,type)

        ## I'm going to experiment with adding the functionality to conver to lower case, and remove
        ## all white space except single space including \n\t
        ## Also, if the thing you are trying to add is only whitespace, then don't add anything. 
        text = text.split.join(" ").downcase

        if text != ""
            if output.has_key?(text)
                output[text]['count']+=1
            else
                output[text] = {
                    'count'   =>  1      ,
                    'shingle_type'    =>  type   ,
                }
            end  
        end
    end

    ## Tried to add a process unknown function but ran into some trouble with scope

    ## Should definitely add something here for printing output to CSV

    ## Perhaps even something for printing output to Pleco flash card format



    def to_csv(output, filepath, headers = ['word','count','shingle_type'])
        ## CSV Output 
        #output = new_token_dict.merge(output)
        if output.length > 0 
            #headers = ['word','count','type']
            #filepath = 'C:\Users\JamesM\Projects\Programming\MandarinVocab\outputfiles\fakelove\fakelove_lm'+timestamp+'.csv'
            CSV.open(filepath, 'w') do |csv|
                csv.to_io.write "\uFEFF" # use CSV#to_io to write BOM directly 
                csv << headers
                output.each do |word, attributes|    
                    csv << [word, *attributes.values_at("count", "shingle_type")]
                end
            end
        end
    end




end

=begin
class Stopwords

    def initialize
    end
                ## Parens
    @@stopwords = Set["（" , "）" , "〈" , "〉" , "《" , "》" , "［" , "］" , "｛" , "｝" , "｜" , "{" , "}" , "[" , "]" , "＜" , "＞" ,
                ## Puncuation
                "、" , "。" , "！" , "-" , "“" , "”" , "," , "." , ":" , "，" , "：" , "；" , "？" , "!" , "?" , "." ,
                ## Numbers
                "０" , "１" , "２" , "３" , "４" , "５" , "６" , "７" , "８" , "９" ,
                "0" , "1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" ,
                ## English Letters
                "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                ## Other
                "\n" , " " , "＠" , "～" , "￥" , "＆" , "＊" , "＋" , "＃" , "＄" , "％" , "︿"]

    attr_accessor :stopwords
end
=end
