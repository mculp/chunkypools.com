class Coin
  attr_accessor :name, :code, :reward, :port, :active

  def initialize(options)
    @name = options[:name]
    @code = options[:code]
    @reward = options[:reward]
    @port = options[:port]
    @active = options.has_key?(:active) ? options[:active] : true
  end
end
