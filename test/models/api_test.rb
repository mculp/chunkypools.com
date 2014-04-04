require 'test_helper'

class ApiTest < ActiveSupport::TestCase
  class EndpointTest < ActiveSupport::TestCase
    test "endpoint should create an endpoint url for two path parts" do
      assert_equal "https://chunkypools.com/api/coin/exchange_rates", Api::Endpoint::Coin.exchange_rates
    end

    test "endpoint should create an endpoint url for three path parts" do
      assert_equal "https://chunkypools.com/api/coin/exchange_rates/yesterday", Api::Endpoint::Coin::ExchangeRates.yesterday
    end

    test "endpoint should create an endpoint url for three path parts, allowing multiple declarations per call" do
      assert_equal "https://chunkypools.com/api/coin/exchange_rates/current", Api::Endpoint::Coin::ExchangeRates.current
    end
  end  
end
