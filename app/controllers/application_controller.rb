class ApplicationController < ActionController::Base

  ## Most of the code in here is for handling guest users

  protect_from_forgery
  check_authorization unless: :devise_controller?

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_current_user

  ## If user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  ## Find guest_user object associated with the current session, creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user
  end

  private
  ## Called (once) when the user logs in, insert any code your application needs
  ## to hand off from guest_user to current_user.
  def logging_in

    ## Transfer input texts
    guest_input_texts = guest_user.input_texts.all
    guest_input_texts.each do |input_text|
      input_text.user_id = current_user.id
      input_text.save()
    end

    ## Transfer known words
    guest_known_words = guest_user.known_words.all
    guest_known_words.each do |known_word|
      known_word.user_id = current_user.id
      known_word.save()
    end

  end

  def create_guest_user
    u = User.create(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com", :guest => true)
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end


  private
  def set_current_user
    Current.user = current_or_guest_user
  end

  protected
  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :username, :name])
  end

end


## Other Stuff
=begin
  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      puts "current user was nil"
      #session[:next] = request.fullpath
      #redirect_to login_url, alert: 'You have to log in to continue.'
    else
      puts "current_user_was not nil"
      #respond_to do |format|
      #  format.json { render nothing: true, status: :not_found }
      #  format.html { redirect_to main_app.root_url, alert: exception.message }
      #  format.js   { render nothing: true, status: :not_found }
      #end
    end
  end
=end