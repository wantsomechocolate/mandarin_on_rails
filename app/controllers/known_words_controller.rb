class KnownWordsController < ApplicationController


  load_and_authorize_resource

  def index
    
    @known_words = current_or_guest_user.known_words

  end


  def show
    @known_word = KnownWord.find(params[:id])
  end


  def new
    @known_word = KnownWord.new
  end

  def create
  
    @known_word = KnownWord.new(known_word_params)

	  @known_word['user_id'] = current_or_guest_user.id

    if @known_word.save
      ## this works by looking at the prefixes for the paths
      ## we find known_word, which knows then to find the ID 
      ## because its in the route definition
      #redirect_to @known_word 
      redirect_to known_words_url
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @known_word = KnownWord.find(params[:id])
  end

  def update
    @known_word = KnownWord.find(params[:id])

    if @known_word.update(known_word_params)
      redirect_to @known_word
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @known_word = KnownWord.find(params[:id])
    @known_word.destroy

    #redirect_to root_path, status: :see_other
    redirect_to known_words_url, status: :see_other

  end


  def create_ajax

    @known_word = KnownWord.new(known_word_params_ajax)
    @known_word['user_id'] = current_or_guest_user.id

    if @known_word.save
      flash.notice = @known_word.word+" marked as known"
      redirect_back(fallback_location: root_path)
    else
      #render :new, status: :unprocessable_entity
      flash.warning = "There was a problem, the word was not marked"
      redirect_back(fallback_location: root_path)
    end
  end



  private
    def known_word_params
      params.require(:known_word).permit(:word)
      #params.permit(:word)
    end

    def known_word_params_ajax
      params.permit(:word)
    end


end
