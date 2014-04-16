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

    attr_accessor :pair_data
    attr_accessor :name, :volume, :high, :low, :last

    def initialize(pair_data)
      @pair_data = pair_data
    end

    def attributes
      {
        'name' => name,
        'volume' => volume,
        'high' => high,
        'low' => low,
        'last' => last
      }
    end

    def format
      format = { :name => 'MarketName' }
      Hash[[:volume, :high, :low, :last].map { |attr| [attr, attr.capitalize] }].merge(format)
    end

    def run
      format.each_pair do |key, bittrex_key|
        instance_variable_set("@#{key}", pair_data[bittrex_key])
      end

      self
    end

    # def as_json(options = {})
    #   super(except: [:pair_data])
    # end
  end
end
