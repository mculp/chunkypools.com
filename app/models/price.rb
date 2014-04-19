class Price
  include Concerns::Rethink
  include Concerns::CachedBlock

  attr_accessor :coin, :parsed_body

  def initialize(coin)
    @coin = coin
  end

  def self.retrieve(coin)
    source = determine_source(coin)
    source.new(coin).retrieve
  end

  def self.determine_source(coin)
    sources = coin.price_sources

  end

  def self.current(coin)
    cached("chunky.markets.last") do
      r.db('chunky').table('markets').order_by('index' => r.desc('created_at')).limit(96).run(rethink).to_a
    end
  end

  def retrieve
    @parsed_body = Typhoeus.get_json(url)
    self
  end
end
