class GarbageWordsController < ApplicationController


  load_and_authorize_resource

  def index
    @garbage_words = current_or_guest_user.garbage_words
  end


  def show
    @garbage_word = GarbageWord.find(params[:id])
  end


  def new
    @garbage_word = GarbageWord.new
  end


  def create  
    @garbage_word = GarbageWord.new(garbage_word_params)
	  @garbage_word['user_id'] = current_or_guest_user.id
    if @garbage_word.save
      redirect_to garbage_words_url
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @garbage_word = GarbageWord.find(params[:id])
  end


  def update
    @garbage_word = GarbageWord.find(params[:id])

    if @garbage_word.update(garbage_word_params)
      redirect_to @garbage_word
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @garbage_word = GarbageWord.find(params[:id])
    @garbage_word.destroy
    #redirect_to root_path, status: :see_other
    redirect_to garbage_words_url, status: :see_other
  end


  def create_ajax
    @garbage_word = GarbageWord.new(garbage_word_params_ajax)
    if @garbage_word.save
      render :json => {"staus" => "success"}
    else
      render :json => {"staus" => "failure"}
    end 
  end


  private
    ## the form and the ajax call were requiring params in two different formats
    def garbage_word_params
      params.require(:garbage_word).permit(:word)
      #params.permit(:word)
    end

    def garbage_word_params_ajax
      params.permit(:user_id, :word)
    end

end


=begin    
    @garbage_word = GarbageWord.new(garbage_word_params_ajax)
    @garbage_word['user_id'] = current_or_guest_user.id

    if @garbage_word.save
      flash.notice = @garbage_word.word+" marked as garbage"
      redirect_back(fallback_location: root_path)
    else
      #render :new, status: :unprocessable_entity
      flash.warning = "There was a problem, the word was not marked"
      redirect_back(fallback_location: root_path)
    end 
=end