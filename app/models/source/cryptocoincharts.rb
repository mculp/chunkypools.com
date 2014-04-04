module Source
  class Cryptocoincharts < Price
    def url
      "http://www.cryptocoincharts.info/v2/api/tradingPair/#{coin.code.downcase}_btc"
    end

    def current_price
      parsed_body['price'].to_f
    end

    def yesterday_price
      parsed_body['price_before_24h'].to_f
    end
  end
end