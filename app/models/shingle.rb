class Shingle < ApplicationRecord
	belongs_to :input_text
	enum :shingle_type, { unknown: 0, dictionary: 1, user: 2, community: 3, token: 4 }
end
