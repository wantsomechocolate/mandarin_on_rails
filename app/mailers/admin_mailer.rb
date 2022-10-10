#class AdminMailer < ApplicationMailer
#end


class AdminMailer < Devise::Mailer
  default from: 'mandarinonrails@gmail.com'
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    mail(to: 'wantsomechocolate@gmail.com', subject: 'New User Awaiting Admin Approval')
  end
end