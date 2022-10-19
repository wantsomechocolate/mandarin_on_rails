## Controller instance variables e.g. @var can, can be accessed by the view!
class ArticlesController < ApplicationController

  #helper_method :current_or_guest_user

  #http_basic_authenticate_with name: "dhh", password: "secret" #, except: [:index, :show]

  #before_action :authenticate_user!, :except => [:show]
  
  def index
    @test = current_or_guest_user
    @articles = Article.all

  end


  def show
    @article = Article.find(params[:id])
  end


  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      ## this works by looking at the prefixes for the paths
      ## we find article, which knows then to find the ID 
      ## because its in the route definition
      redirect_to @article 
    else
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end