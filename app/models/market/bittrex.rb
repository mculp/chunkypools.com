class Market::Bittrex < Market
  def url
    "https://bittrex.com/api/v1/public/getmarketsummaries"
  end

  def pairs
    response.result.map do |pair|
      BittrexPair.new(pair).run
    end
  end

  class BittrexPair
    include ActiveModel::Serializers::JSON
    include Market::Pair

    def format
      Hash[[:volume, :high, :low, :last].map { |attr| [attr, attr.capitalize] }]
    end

    def run
      market_name = pair_data['MarketName']
      partitioned_market_name = market_name.partition("-")

      self.base = partitioned_market_name.first
      self.quote = partitioned_market_name.last
      self.name = "#{quote}/#{base}"

      super
    end
  end
end
