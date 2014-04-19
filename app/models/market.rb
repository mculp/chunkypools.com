class Market
  include ActiveModel::Serializers::JSON

  attr_accessor :response
  attr_accessor :name, :pairs

  def initialize
    raise if self.class.name == 'Market'

    @name = self.class.name.demodulize.underscore
    @response = Typhoeus.get_json_as_object(url)

    super
  end

  def attributes
    { 'name' => name, 'pairs' => pairs }
  end

  def self.all
    market_list.map { |file| by_name(file.split(".rb").first) }
  end

  def self.market_list
    @market_list ||= begin
      path = File.expand_path("../market/*", __FILE__)
      files = Dir[path]

      # pair.rb is the module, the rest are markets
      files.reject { |file| file =~ /pair\.rb$/ }

      files.map { |file| File.basename(file, ".rb") }
    end
  end

  def self.by_name(name)
    Market.const_get(name.to_s.camelize).new
  end
end
