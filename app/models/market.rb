class Market
  include ActiveModel::Serializers::JSON

  attr_accessor :response
  attr_accessor :name, :pairs

  def initialize
    raise if self.name == 'Market'

    @name = self.name.underscore
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
    name.camelize.constantize.new.convert
  end

  def convert
  end
end
