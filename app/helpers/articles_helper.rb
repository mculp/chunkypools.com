module ArticlesHelper
  def article_header(article, article_counter)
    header = truncate(article.header, length: 80)
    link_to header, "/articles/#{article_counter + 1}-#{header.parameterize}" 
  end
end
