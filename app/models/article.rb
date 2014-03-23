require_relative 'mpos/api'

class Article
  def self.all
    api = MPOS::API.new('posts')

    api.get :newsposts
  end

  def self.find(id)
    posts = all
    posts[id - 1]
  end
end
