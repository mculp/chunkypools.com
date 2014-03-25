class ArticlesController < ApplicationController
  def index
    login_from_php

    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end
end
