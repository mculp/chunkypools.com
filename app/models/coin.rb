class Coin
  include CoinConfig

  attr_accessor :name, :code, :reward, :port, :active, :price_sources, :type
  attr_accessor :algorithm, :source_attribute, :alert, :label_color

  def initialize(options)
    @name = options[:name]
    @code = options[:code]
    @reward = options[:reward]
    @port = options[:port]
    @label_color = options[:label_color]
    @active = options.has_key?(:active) ? options[:active] : true
    @price_sources = options[:price_sources]
    @type = options[:type] || 'mpos'
    @algorithm = options[:algorithm] || 'scrypt'
  end

  def self.all
    CONTAINER
  end

  def self.[](code)
    CONTAINER.find { |c| c.code == code.downcase }
  end

  def self.active
    @active ||= CONTAINER.select(&:active)
  end

  def self.active_mpos
    CONTAINER.select { |c| c.active && c.type == 'mpos' }
  end

  def self.scrypt
    CONTAINER.select { |c| c.active && c.algorithm == 'scrypt' }
  end

  def self.x11
    CONTAINER.select { |c| c.active && c.algorithm == 'x11' }
  end

  def self.sha256
    CONTAINER.select { |c| c.active && c.algorithm == 'sha256' }
  end
end
