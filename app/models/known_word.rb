class KnownWord < ApplicationRecord

	belongs_to :user 
	validates :word, presence: true
	validates_uniqueness_of :word

end
