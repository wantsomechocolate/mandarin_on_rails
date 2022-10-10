class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, 
         :omniauthable

  ## Only allows users that have been approved to login
  def active_for_authentication? 
    super && approved?
  end   
  def inactive_message 
    approved? ? super : :not_approved
  end

  ## Relationships
  has_one_attached :avatar, dependent: :destroy
  has_many :input_texts, dependent: :destroy
  has_many :user_words, dependent: :destroy
  has_many :known_words, dependent: :destroy

  ## Validations
  validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
    file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }

  ## For sending emails to me if a user registers
  #after_create :send_admin_mail
  #def send_admin_mail
  #  if not guest
  #   AdminMailer.new_user_waiting_for_approval(email).deliver
  #  end
  #end

  ## For sending emails to me after a user confirms their email address
  ## This is overriding a devise function that gets called after user confirmation, apparently
  def after_confirmation
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end


  ## Don't send emails to guest email addresses
  def confirmation_required?
    if guest 
      return false
    else
      return true 
    end
  end



end
