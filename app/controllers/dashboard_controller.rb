class DashboardController < ApplicationController
  include RethinkDB::Shortcuts

  def show
    login_from_php

    if cached_response = Rails.cache.read("api/pool/status")
      @pool_info = cached_response
    else
      body = Typhoeus.get("http://www.chunkypools.com/api/pool/status", nosignal: true).response_body
      @pool_info = Hashie::Mash.new(JSON.parse(body))
      Rails.cache.write("api/pool/status", @pool_info)
    end

    @multiport_coin = @pool_info.multiport_coin
    @multiport_workers = @pool_info.multiport_workers
    @hash_rate = @pool_info.hash_rate

    r.connect(host: "ec2-23-21-221-6.compute-1.amazonaws.com", port: 28015).repl
    @raw_results = r.db('chunky').table('historical').limit(96).order_by(r.desc('created_at')).run

    results = @raw_results.reverse.map.with_index do |result, i|
      [{ x: result['created_at'].to_i * 1000, y: result['hash_rate'] }, { x: result['created_at'].to_i * 1000, y: result['workers'] }]
    end.transpose

    object1 = { area: true, key: "Hashrate", values: results[0] }
    object2 = { area: false, key: "Workers", values: results[1] }

    @results = [object1, object2]

    @pools_table = @pool_info.pools.sort_by { |p| -p.hash_rate }

    sparkline_source = @raw_results.reverse.values_at(0,10,20,30,40,50,60,70,80,95)

    @sparklines = @pools_table.reject { |p| p.coin == "POT" || p.coin == 'LEAF' }.map do |pool|
      sparkline_source.map { |source| source['pools'].find { |s| s['coin'] == pool.coin }['hash_rate'] }
    end

    @sparkline_order = @pools_table.map(&:coin)
  end
end
