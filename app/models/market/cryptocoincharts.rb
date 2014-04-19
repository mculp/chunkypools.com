class Market::Cryptocoincharts < Market
  def url
    "http://www.cryptocoincharts.info/v2/api/listCoins"
  end

  def pairs
    response.map do |pair|
      CryptocoinchartsPair.new(pair).run
    end
  end

  class CryptocoinchartsPair
    include ActiveModel::Serializers::JSON
    include Market::Pair

    def format
      {
        volume: 'volume_btc',
        last: 'price_btc',
        quote: 'name'
      }
    end

    def run
      super

      self.base = "BTC"
      self.name = "#{quote}/#{base}"

      self
    end
  end
end

