class Cache
  def get(request)
    Rails.cache.read(request)
  end

  def set(request, response)
    Rails.cache.write(request, response)
  end
end

Typhoeus::Config.cache = Cache.new
