module DashboardHelper
  def massage
    massage_for_chart
    massage_for_pools_table
    massage_for_sparklines
  end

  def massage_for_chart
    results = @display_data.reverse.map.with_index do |result, i|
      [
        { x: result['created_at'].to_i * 1000, y: result['hash_rate'] },
        { x: result['created_at'].to_i * 1000, y: result['workers'] }
      ]
    end.transpose

    object1 = { area: true, key: "Hashrate", values: results[0] }
    object2 = { area: false, key: "Workers", values: results[1] }

    @results = [object1, object2]
  end

  def massage_for_pools_table
    @pools_table = @latest_display_data.pools.sort_by { |p| -p.hash_rate }
  end

  def massage_for_sparklines
    sparkline_source = @display_data.last(10)

    @sparklines = @pools_table.map do |pool|
      sparkline_source.map do |source|
        found_pool = source['pools'].find { |s| s['coin'] == pool.coin }
        found_pool.try(:[], 'hash_rate')
      end
    end

    @sparkline_order = @pools_table.map(&:coin)
  end
end
