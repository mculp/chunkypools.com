class Market::Mintpal < Market
  def url
    "https://api.mintpal.com/v1/market/summary/BTC"
  end

  def pairs
    response.map do |pair|
      MintpalPair.new(pair).run
    end
  end

  class MintpalPair
    include ActiveModel::Serializers::JSON
    include Market::Pair

    def format
      {
        volume: '24hvol',
        high: '24hhigh',
        low: '24hlow',
        last: 'last_price',
        base: 'exchange',
        quote: 'code'
      }
    end

    def run
      super

      self.name = "#{quote}/#{base}"

      self
    end
  end
end
