module Typhoeus
  def self.get_json(url)
    body = get(url, ssl_verifypeer: false, nosignal: true).response_body
    JSON.parse(body) 
  end 

  def self.get_json_as_object(url)
    body = get_json(url)

    if body.is_a? Array
      body.map { |b| Hashie::Mash[b] }
    else
      Hashie::Mash[body]
    end
  end
end

class Cache
  def get(request)
    Rails.cache.read(request)
  end

  def set(request, response)
    Rails.cache.write(request, response)
  end
end

Typhoeus::Config.cache = Cache.new

