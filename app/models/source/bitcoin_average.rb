module Source
  class BitcoinAverage < Price
    def url
      "https://api.bitcoinaverage.com/ticker/USD/"
    end

    def current_price
      parsed_body['last']
    end

    def yesterday_price
      parsed_body['24h_avg']
    end
  end 
end