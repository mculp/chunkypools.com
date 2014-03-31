class Coin
  attr_accessor :name, :code, :reward, :port, :active

  def initialize(options)
    @name = options[:name]
    @code = options[:code]
    @reward = options[:reward]
    @port = options[:port]
    @active = options.has_key?(:active) ? options[:active] : true
  end

  CONTAINER = [
   Coin.new(name: 'Dogecoin', code: 'doge', reward: 250000, host: 'doge.chunkypools.com', port: 3333),
   Coin.new(name: 'RonPaulCoin', code: 'rpc', reward: 1, port: 3335),
   Coin.new(name: 'Rubycoin', code: 'ruby', reward: 500, port: 3342),
   Coin.new(name: 'Digibyte', code: 'dgb', reward: 8000, port: 3340),
   Coin.new(name: 'Klondikecoin', code: 'kdc', reward: 77, port: 3341),
   Coin.new(name: 'Potcoin', code: 'pot', reward: 420, port: 3420),
   Coin.new(name: 'Suncoin', code: 'sun', reward: 10, port: 3345),
   Coin.new(name: 'Procoin', code: 'pcn', reward: 1000, port: 3347),
   Coin.new(name: 'Spartancoin', code: 'spn', reward: 150000, port: 3348),
   Coin.new(name: 'Auroracoin', code: 'aur', reward: 25, port: 3346, active: false),
   Coin.new(name: 'Flappycoin', code: 'flap', reward: 500000, port: 3343, active: false),
   Coin.new(name: 'RonSwansonCoin', code: 'ron', reward: 0.125, port: 3344, active: false),
   Coin.new(name: 'Dogecoin', code: 'doge', reward: 250000, port: 3333, active: false),
   Coin.new(name: 'Earthcoin', code: 'eac', reward: 11000, port: 3334, active: false),
   Coin.new(name: 'Lottocoin', code: 'lot', reward: 32000, port: 3336, active: false),
   Coin.new(name: 'Stablecoin', code: 'sbc', reward: 25, port: 3337, active: false),
   Coin.new(name: '42', code: '42', reward: 0.000042, port: 3338, active: false),
   Coin.new(name: 'Litecoin', code: 'ltc', reward: 50, port: 3340, active: false),
   Coin.new(name: 'Leafcoin', code: 'leaf', reward: 500000, port: 3342, active: false)
  ]

  def self.all
    CONTAINER
  end

  def self.active
    @active ||= CONTAINER.select(&:active)
  end
end
