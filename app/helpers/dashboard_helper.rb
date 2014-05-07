module DashboardHelper
  def massage
    [:scrypt, :x11, :sha256].each do |algo|
      massage_for_chart algo
      massage_for_pools_table algo
      massage_for_sparklines algo
    end
  end

  def massage_for_chart(algo)
    @results ||= {}

    results = @display_data.reverse.map.with_index do |result, i|
      result_algo = result[algo.to_s]
      [
        { x: result['created_at'].to_i * 1000, y: result_algo['hash_rate'] },
        { x: result['created_at'].to_i * 1000, y: result_algo['workers'] }
      ]
    end.transpose

    object1 = { area: true, key: "Hashrate", values: results[0] }
    object2 = { area: false, key: "Workers", values: results[1] }

    @results[algo] = [object1, object2]
  end

  def massage_for_pools_table(algo)
    @pools_table ||= {}
    @pools_table[algo] = @latest_display_data.public_send(algo).pools.sort_by { |p| -p.hash_rate }
  end

  def massage_for_sparklines(algo)
    sparkline_source = @display_data.first(10).reverse

    @sparklines ||= {}
    @sparkline_order ||= {}

    @sparklines[algo] = @pools_table[algo].map do |pool|
      sparkline_source.map do |source|
        found_pool = source[algo.to_s]['pools'].find { |s| s['coin'] == pool.coin }
        found_pool.try(:[], 'hash_rate')
      end
    end

    @sparkline_order[algo] = @pools_table[algo].map(&:coin)
  end
end
