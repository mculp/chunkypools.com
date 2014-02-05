require 'open-uri'

class Pool
  API_KEY = "05d16735674051d72ea5f0ce0b60adde14e66544b388bf0b313aef9a2be65314"

  COIN_REWARD = {
   'doge' => 500000,
   'eac' => 11000,
   'rpc' => 1,
   'lot' => 32000,
   'sbc' => 25,
   '42' => 0.000042,
   'dgb' => 8000,
   'ltc' => 50,
   'kdc' => 77,
   'leaf' => 500000,
   'pot' => 420
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
    pools = COIN_REWARD.keys.map do |coin|
      new(coin).pool_status.merge(coin: coin.upcase)
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
    COIN_REWARD.keys.map do |coin|
      response = new(coin).balance(api_key)

      { coin: coin, confirmed: response['confirmed'], unconfirmed: response['unconfirmed'] }
    end
  end

  private

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
    "http://pool.chunky.ms/#{coin}/index.php?page=api&api_key=#{api_key}"
  end

  def action(action, api_key)
    url(api_key) + "&action=#{action}"
  end
end
