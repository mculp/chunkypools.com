module MPOS
  class API
    class_attribute :api_key, :hostname

    self.api_key = '05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314'
    self.hostname = 'https://chunkypools.com'


    attr_accessor :coin

    def initialize(coin, api_key = nil)
      @coin = coin
      @api_key = api_key if api_key
    end


    def api_key
      @api_key || self.class.api_key
    end


    def get(action)
      begin
        action = "get#{action}"
        body = Typhoeus.get(url(action), nosignal: true).response_body
        JSON.parse(body)[action]['data']
      rescue Exception => e
        Rails.logger.debug "We ran into a problem trying to hit the mpos endpoint."
        Rails.logger.debug "action: #{action}, url: #{url(action)}, body: #{body}"
        Rails.logger.debug e.inspect

        { error: true }
      end
    end

    def get_wrapped(action)
      parsed_response = get(action)

      if parsed_response.is_a? Array
        parsed_response.map { |h| Hashie::Mash[h] }
      else
        Hashie::Mash[parsed_response]
      end
    end

    def url(action)
      "%s/%s/index.php?page=api&api_key=%s&action=%s" % [self.class.hostname, coin, api_key, action]
    end


    def seconds_to_minutes_and_hours(seconds)
      return [0, 1] if seconds < 60

      mm, ss = seconds.divmod(60)
      hh, mm = mm.divmod(60)
    end
  end
end
