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

  def self.balance(coin, api_key)
    api = MPOS::API.new(coin, api_key)
    api.get :userbalance
  end

  def self.worker(coin, api_key)
    api = MPOS::API.new(coin, api_key)
    api.get :userworkers
  end



  def self.statuses(algorithms = [:scrypt, :x11, :sha256])
    algorithms = Array(algorithms)

    algorithms.inject({}) do |output, algo|
      pools = Coin.public_send(algo).map do |coin|
        code = coin.code

        begin
          status(code).merge(coin: code.upcase)
        rescue Exception => e
          Rails.logger.info e.inspect
          next
        end
      end.compact

      next unless pools.present?

      hash_rate = pools.inject(0) { |sum, n| sum += n[:hash_rate] }
      workers = pools.inject(0) { |sum, n| sum += n[:number_of_workers] }

      best_hash = pools.max_by { |pool| pool[:hash_rate] }
      best_hash_rate = best_hash[:coin]
      best_hash_rate_value = best_hash[:hash_rate]

      most = pools.max_by { |pool| pool[:number_of_workers] }
      most_workers = most[:coin]
      most_workers_value = most[:number_of_workers]

      algo_hash = {
        algo => {
          multiport_coin: multiport_coin(algo),
          multiport_workers: multiport_workers(algo),
          hash_rate: hash_rate,
          workers: workers,
          best_hash_rate: best_hash_rate,
          best_hash_rate_value: best_hash_rate_value,
          most_workers: most_workers,
          most_workers_value: most_workers_value,
          pools: pools
        }
      }

      output.merge(algo_hash)
    end
  end

  def self.balances(api_key)
    Coin.active_mpos.map do |coin|
      code = coin.code

      response = balance(code, api_key) rescue next

      { coin: code, confirmed: response['confirmed'], unconfirmed: response['unconfirmed'] }
    end.compact
  end

  def self.workers(api_key)
    active_workers = []

    Coin.active_mpos.each do |coin|
      code = coin.code

      response = worker(code, api_key) rescue next

      workers = response.select { |worker| worker['hashrate'] && worker['hashrate'] > 0 }

      next unless workers.present?

      workers.each do |worker|
        active_workers << { coin: code.upcase, username: worker['username'], hash_rate: worker['hashrate'] }
      end
    end

    active_workers
  end


  private

  def self.multiport_coin(algo)
    coin_line = File.read("data/multiport_coin_#{algo}.txt")

    coin_line.split(',')[1].upcase
  end

  def self.multiport_workers(algo)
    File.read("data/multiport_workers_#{algo}.txt").to_i
  end

  def self.seconds_to_minutes_and_hours(seconds)
    return [0, 1] if seconds < 60

    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
  end
end
