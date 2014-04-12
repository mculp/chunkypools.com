require_relative 'mpos/api'

class Article < Hashie::Mash
  def self.all
    api = MPOS::API.new('posts')

    api.get(:newsposts).map { |r| Article[r] }
  end

  def self.find(id)
    posts = all
    posts[id.to_i]
  end

  def to_partial_path
    'articles/article'
  end
end
