class Dashboard
  include RethinkDB::Shortcuts
  extend RethinkConnection

  def self.display_data
    cached("chunky.historical.96.created_at.desc") do
      r.db('chunky').table('historical').order_by('index' => r.desc('created_at')).limit(96).run(rethink).to_a
    end
  end

  def self.cached(key)
    if cached_results = Rails.cache.read(key)
      return cached_results
    end

    results = yield

    Rails.cache.write(key, results)

    results
  end
end
