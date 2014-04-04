module Typhoeus
  def self.get_json(url)
    body = get(url, ssl_verifypeer: false, nosignal: true).response_body
    JSON.parse(body) 
  end 

  def self.get_json_as_object(url)
    Hashie::Mash[get_json(url)]
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

