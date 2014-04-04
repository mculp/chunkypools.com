class Api
  DOMAIN = 'https://chunkypools.com/'
  URL = DOMAIN + 'api/'

  class Endpoint
    def self.evaluate(name)
      endpoint_index = ancestors.index { |a| a.name.demodulize == 'Endpoint' }

      relevant_ancestors = ancestors[0...endpoint_index].reverse
      relevant_ancestors.map! { |a| a.name.demodulize.underscore }

      Api::URL + relevant_ancestors.join("/") + "/" + name
    end

    def self.endpoint(*args)
      args.each do |arg|
        define_singleton_method(arg) { evaluate(arg.to_s) }
      end
    end

    class Coin < Endpoint
      endpoint :exchange_rates

      class ExchangeRates < Coin
        endpoint :yesterday, :current
      end
    end
  end  
end