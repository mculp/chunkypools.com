require_relative 'mpos/api'

class Pool
  def self.status(coin)
    api = MPOS::API.new(coin)
    response = api.get :poolstatus

    {
      hash_rate: response['hashrate'] / 1000,
      number_of_workers: response['workers'],
      difficulty: response['networkdiff'],
      average_block_time: seconds_to_minutes_and_hours(response['esttime']),
      time_since_last_block: seconds_to_minutes_and_hours(response['timesincelast'])
    }
  end

  def self.balance(api_key)
    api = MPOS::API.new(coin, api_key)
    api.get :userbalance
  end

  def self.workers(api_key)
    api = MPOS::API.new(coin, api_key)
    api.get :userworkers
  end



  def self.statuses
    pools = Coin.active.map do |coin|
      code = coin.code
      status(code).merge(coin: code.upcase)
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
    Coin.active.map do |coin|
      code = coin.code
      response = balance(code, api_key)

      { coin: code, confirmed: response['confirmed'], unconfirmed: response['unconfirmed'] }
    end
  end

  def self.workers(api_key)
    active_workers = []

    Coin.active.each do |coin|
      code = coin.code
      response = workers(code, api_key)

      workers = response.select { |worker| worker['hashrate'] && worker['hashrate'] > 0 }

      next unless workers.present?

      workers.each do |worker|
        active_workers << { coin: code.upcase, username: worker['username'], hash_rate: worker['hashrate'] }
      end
    end

    active_workers
  end


  private

  def self.multiport_coin
    coin_line = File.read('data/multiport_coin.txt')

    coin_line.split(',')[1].upcase
  end

  def self.multiport_workers
    File.read('data/multiport_workers.txt').to_i
  end

  def self.seconds_to_minutes_and_hours(seconds)
    return [0, 1] if seconds < 60

    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
  end
end
