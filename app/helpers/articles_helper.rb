module ArticlesHelper
  def article_header(article, article_counter)
    header = truncate(article.header, length: 80)
    id = @number_of_articles ? (@number_of_articles - 1) - article_counter : article_counter 
    link_to header, "/articles/#{id}-#{header.parameterize}" 
  end
end
