class ArticlesController < ApplicationController
  def index
    login_from_php

    @articles = Article.all
    @number_of_articles = @articles.size
  end

  def show
    @article = Article.find(params[:id])
  end
end
