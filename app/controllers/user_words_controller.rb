class UserWordsController < ApplicationController

  load_and_authorize_resource

  def index
    
    @user_words = current_or_guest_user.user_words

  end


  def show
    @user_word = UserWord.find(params[:id])
  end


  def new
    @user_word = UserWord.new
  end

  def create
  
    @user_word = UserWord.new(user_word_params)

	@user_word['user_id'] = current_or_guest_user.id

    if @user_word.save
      ## this works by looking at the prefixes for the paths
      ## we find user_word, which knows then to find the ID 
      ## because its in the route definition
      redirect_to @user_word 
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @user_word = UserWord.find(params[:id])
  end

  def update
    @user_word = UserWord.find(params[:id])

    if @user_word.update(user_word_params)
      redirect_to @user_word
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_word = UserWord.find(params[:id])
    @user_word.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def user_word_params
      params.require(:user_word).permit(:word, :known, :definition)
    end




end
