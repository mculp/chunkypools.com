class Price
  attr_accessor :coin, :parsed_body

  def initialize(coin)
    @coin = coin
  end

  def self.retrieve(coin)
    source = determine_source(coin)
    source.new(coin).retrieve
  end

  def self.determine_source(coin)
    case coin.price_source
    when 'mintpal'
      Source::Mintpal
    else
      Source::Cryptocoincharts
    end
  end

  def retrieve
    @parsed_body = Typhoeus.get_json(url)
  end
end