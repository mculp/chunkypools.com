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

  def self.current(coin)
    cached("chunky.price.current.#{coin.code}") do
      { coin: coin.code, exchange_rate: max_exchange_rate_from_market_summary(latest_market_summary, coin) }
    end
  end

  def self.latest_market_summary
    cached("chunky.markets.last") do
      json = r.db('chunky').table('markets').order_by('index' => r.desc('created_at')).limit(1).run(rethink).to_a.first
      Hashie::Mash.loose(json)
    end
  end

  def self.max_exchange_rate_from_market_summary(market_summary, coin)
    relevant_markets = market_summary.markets.select do |market|
      market.name.in? coin.price_sources
    end

    current_prices = relevant_markets.map do |market|
      relevant_pair = market.pairs.find do |pair|
        quote = coin.source_attribute ? coin.public_send(coin.source_attribute) : coin.code.upcase
        pair.name == "#{quote}/BTC"
      end

      relevant_pair && relevant_pair.last.to_f
    end

    current_prices.max || 0
  end

  def retrieve
    @parsed_body = Typhoeus.get_json(url)
    self
  end
end
