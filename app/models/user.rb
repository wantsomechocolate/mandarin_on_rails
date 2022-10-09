class User < ApplicationRecord



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, 
         :omniauthable


  def active_for_authentication? 
    super && approved?
  end 
  
  def inactive_message 
    approved? ? super : :not_approved
  end


  has_one_attached :avatar, dependent: :destroy

  has_many :input_texts, dependent: :destroy
  has_many :user_words, dependent: :destroy
  has_many :known_words, dependent: :destroy

  ## Validations
  validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
    file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }




end

#id
#email
#sign_in_count
#current_sign_in_ip
#unconfirmed_email
#guest
#username
#name
#approved