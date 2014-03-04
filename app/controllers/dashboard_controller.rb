class DashboardController < ApplicationController
  include RethinkDB::Shortcuts

  def show
    login_from_php

    @pool_info = cached(Settings::STATUS_PATH) do
      body = Typhoeus.get(Settings::API + Settings::STATUS_PATH, nosignal: true).response_body
      Hashie::Mash.new(JSON.parse(body))
    end

    @multiport_coin = @pool_info.multiport_coin
    @multiport_workers = @pool_info.multiport_workers
    @hash_rate = @pool_info.hash_rate

    @raw_results = cached("chunky.historical.96.created_at.desc") do
      connection = r.connect(host: Settings::RETHINK, port: 28015)
      r.db('chunky').table('historical').order_by('index' => r.desc('created_at')).limit(96).run(connection).to_a
    end

    results = @raw_results.reverse.map.with_index do |result, i|
      [{ x: result['created_at'].to_i * 1000, y: result['hash_rate'] }, { x: result['created_at'].to_i * 1000, y: result['workers'] }]
    end.transpose

    object1 = { area: true, key: "Hashrate", values: results[0] }
    object2 = { area: false, key: "Workers", values: results[1] }

    @results = [object1, object2]

    @pools_table = @pool_info.pools.sort_by { |p| -p.hash_rate }

    sparkline_source = @raw_results.last(10)

    @sparklines = @pools_table.map do |pool|
      sparkline_source.map { |source| source['pools'].find { |s| s['coin'] == pool.coin }.try(:[], 'hash_rate') }.compact
    end

    @sparkline_order = @pools_table.map(&:coin)
  end

  def cached(key)
    if cached_results = Rails.cache.read(key)
      return cached_results
    end

    results = yield

    Rails.cache.write(key, results)

    results
  end
end
