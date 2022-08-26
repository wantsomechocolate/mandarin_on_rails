class InputText < ApplicationRecord
	#include Visible

	belongs_to :user

	has_one_attached :avatar

	has_many :shingles, dependent: :destroy

	validates :title, presence: true
	validates :body, presence:true #, length: {minimum: 10}

  	validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
    file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }

	#attribute :public, :boolean, default: false
end
