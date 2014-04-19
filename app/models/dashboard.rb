class Dashboard
  include Concerns::Rethink
  include Concerns::CachedBlock

  def self.display_data
    cached("chunky.historical.96.created_at.desc") do
      r.db('chunky').table('historical').order_by('index' => r.desc('created_at')).limit(96).run(rethink).to_a
    end
  end
end
