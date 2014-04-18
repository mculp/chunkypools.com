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
    # Rails.root + "app/csv/names.csv"
    Dir[File.expand_path("./market", __FILE__)].each { |file| by_name(file.split(".rb").first) }
  end

  def self.by_name(name)
    Market.const_get(name.to_s.camelize).new
  end

  def convert
  end
end
