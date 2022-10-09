class InputText < ApplicationRecord
	#include Visible

	belongs_to :user

	has_one_attached :avatar

	has_many :shingles, dependent: :destroy

	validates :title, presence: true
	validates :body, presence:true #, length: {minimum: 10}

  	validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
    file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }

    ## Validations for guests
    validates :body, length: {maximum:200}, if: -> {user.guest == true}
    validate :input_texts_within_limit, if: -> {user.guest == true}

    def input_texts_within_limit
    	if user.input_texts.all.count >= 5
    		errors.add(:base, "You have exceeded the limit of input texts you can have as a guest")
    	end
    end


	#attribute :public, :boolean, default: false
end
