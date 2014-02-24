class DashboardController < ApplicationController
  include RethinkDB::Shortcuts

  def show
    login_from_php

    if cached_response = Rails.cache.read("api/pool/status")
      @pool_info = cached_response
    else
      body = Typhoeus.get('http://pool.chunky.ms/api/pool/status', nosignal: true).response_body
      @pool_info = Hashie::Mash.new(JSON.parse(body))
      Rails.cache.write("api/pool/status", @pool_info)
    end

    @multiport_coin = @pool_info.multiport_coin
    @multiport_workers = @pool_info.multiport_workers
    @hash_rate = @pool_info.hash_rate

    if cached_results = Rails.cache.read("chunky.historical.96.created_at.desc")
      @raw_results = cached_results
    else
      host = Rails.env.development? ? "localhost" : "ec2-23-21-221-6.compute-1.amazonaws.com"
      connection = r.connect(host: host, port: 28015)
      @raw_results = r.db('chunky').table('historical').order_by('index' => r.desc('created_at')).limit(96).run(connection).to_a
      Rails.cache.write("chunky.historical.96.created_at.desc", @raw_results)
    end

    results = @raw_results.reverse.map.with_index do |result, i|
      [{ x: result['created_at'].to_i * 1000, y: result['hash_rate'] }, { x: result['created_at'].to_i * 1000, y: result['workers'] }]
    end.transpose

    object1 = { area: true, key: "Hashrate", values: results[0] }
    object2 = { area: false, key: "Workers", values: results[1] }

    @results = [object1, object2]

    @pools_table = @pool_info.pools.sort_by { |p| -p.hash_rate }

    sparkline_source = @raw_results.reverse.values_at(0,10,20,30,40,50,60,70,80,95)

    @sparklines = @pools_table.reject { |p| p.coin == "POT" || p.coin == 'RUBY' }.map do |pool|
      sparkline_source.map { |source| source['pools'].find { |s| s['coin'] == pool.coin }['hash_rate'] }
    end

    @sparkline_order = @pools_table.map(&:coin)
  end
end
