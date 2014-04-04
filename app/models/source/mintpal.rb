module Source
  class Mintpal < Price
    def url
      "https://api.mintpal.com/market/stats/#{coin.code.upcase}/BTC"
    end

    def current_price
      parsed_body.first['last_price'].to_f
    end

    def yesterday_price
      parsed_body.first['yesterday_price'].to_f
    end
  end
end