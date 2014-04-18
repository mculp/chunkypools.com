module Market::Pair
  attr_accessor :pair_data
  attr_accessor :name, :quote, :base, :volume, :high, :low, :last

  def initialize(pair_data)
    @pair_data = pair_data
  end

  def attributes
    {
      'name' => name,
      'quote' => quote,
      'base' => base,
      'volume' => volume,
      'high' => high,
      'low' => low,
      'last' => last
    }
  end

  def run
    format.each_pair do |key, market_key|
      instance_variable_set("@#{key}", pair_data[market_key])
    end

    self
  end
end
