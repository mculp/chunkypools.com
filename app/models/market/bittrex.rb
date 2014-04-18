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
      super


    end
  end
end
