require 'open-uri'

class Pool
  API_KEY = "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314"

  COINS = {
   Coin.new(name: 'RonPaulCoin', code: 'rpc', reward: 1, port: 3335),
   Coin.new(name: 'Digibyte', code: 'dgb', reward: 8000, port: 3340),
   Coin.new(name: 'Klondikecoin', code: 'kdc', reward: 77, port: 3341),
   Coin.new(name: 'Potcoin', code: 'pot', reward: 420, port: 3420),
   Coin.new(name: 'Flappycoin', code: 'flap', reward: 500000, port: 3343),
   Coin.new(name: 'RonSwansonCoin', code: 'ron', reward: 0.125, port: 3344),
   Coin.new(name: 'Suncoin', code: 'sun', reward: 10, port: 3345),
   Coin.new(name: 'Auroracoin', code: 'aur', reward: 25, port: 3346),
   Coin.new(name: 'Dogecoin', code: 'doge', reward: 250000, port: 3333, active: false),
   Coin.new(name: 'Earthcoin', code: 'eac', reward: 11000, port: 3334, active: false),
   Coin.new(name: 'Lottocoin', code: 'lot', reward: 32000, port: 3336, active: false),
   Coin.new(name: 'Stablecoin', code: 'sbc', reward: 25, port: 3337, active: false),
   Coin.new(name: '42', code: '42', reward: 0.000042, port: 3338, active: false),
   Coin.new(name: 'Litecoin', code: 'ltc', reward: 50, port: 3340, active: false),
   Coin.new(name: 'Leafcoin', code: 'leaf', reward: 500000, port: 3342, active: false)
  }

  attr_accessor :coin

  def initialize(coin = 'doge')
    @coin = coin
  end

  def pool_status
    response = grab_and_parse :getpoolstatus

    {
      hash_rate: response['hashrate'] / 1000,
      number_of_workers: response['workers'],
      difficulty: response['networkdiff'],
      average_block_time: seconds_to_minutes_and_hours(response['esttime']),
      time_since_last_block: seconds_to_minutes_and_hours(response['timesincelast'])
    }
  end

  def check_for_new_block
    response = grab_and_parse :getpoolstatus
    current_block_number = response['lastblock']

    last_block = self.class.class_variable_get("@@last_#{coin}_block")
    block_found = last_block && last_block != current_block_number

    self.class.class_variable_set("@@last_#{coin}_block", current_block_number)

    block_info if block_found
  end

  def block_info
    response = grab_and_parse :getblocksfound

    block = response.find { |block| block['height'] == self.class.class_variable_get("@@last_#{coin}_block") }

    {
      reward:    block['amount'].to_i,
      worker:    block['worker_name'],
      found_by:  block['finder'],
      shares:    "#{block['shares']} / #{block['estshares']}"
    }
  end

  def balance(api_key)
    grab_and_parse :getuserbalance, api_key
  end

  def self.pool_metastatus
    pools = active_coins.map do |coin|
      code = coin.code
      new(code).pool_status.merge(coin: code.upcase)
    end

    hash_rate = pools.inject(0) { |sum, n| sum += n[:hash_rate] }
    workers = pools.inject(0) { |sum, n| sum += n[:number_of_workers] }
    best_hash_rate = pools.max_by { |pool| pool[:hash_rate] }[:coin]
    most_workers = pools.max_by { |pool| pool[:number_of_workers] }[:coin]

    {
      multiport_coin: multiport_coin,
      multiport_workers: multiport_workers,
      hash_rate: hash_rate,
      workers: workers,
      best_hash_rate: best_hash_rate,
      most_workers: most_workers,
      pools: pools
    }
  end

  def self.balances(api_key)
    active_coins.map do |coin|
      code = coin.code
      response = new(code).balance(api_key)

      { coin: code, confirmed: response['confirmed'], unconfirmed: response['unconfirmed'] }
    end
  end

  private

  def active_coins
    @active_coins ||= COINS.select(&:active)
  end

  def self.multiport_coin
    coin_line = File.read('data/multiport_coin.txt')

    coin_line.split(',')[1].upcase
  end

  def self.multiport_workers
    File.read('data/multiport_workers.txt').to_i
  end

  def seconds_to_minutes_and_hours(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
  end

  def grab_and_parse(action, api_key = API_KEY)
    url = action(action, api_key)
    body = Typhoeus.get(url, nosignal: true).response_body
    JSON.parse(body)[action.to_s]['data']
  end

  def url(api_key)
    "https://chunkypools.com/#{coin}/index.php?page=api&api_key=#{api_key}"
  end

  def action(action, api_key)
    url(api_key) + "&action=#{action}"
  end
end
