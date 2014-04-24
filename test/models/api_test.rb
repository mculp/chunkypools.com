require 'test_helper'

class ApiTest < ActiveSupport::TestCase
  class EndpointTest < ActiveSupport::TestCase
    test "endpoint should create an endpoint url for two path parts" do
      assert_equal "https://chunkypools.com/api/pool/exchange_rates", Api::Endpoint::Pool.exchange_rates
    end

    test "endpoint should create an endpoint url for three path parts" do
      assert_equal "https://chunkypools.com/api/pool/exchange_rates/yesterday", Api::Endpoint::Pool::ExchangeRates.yesterday
    end

    test "endpoint should create an endpoint url for three path parts, allowing multiple declarations per call" do
      assert_equal "https://chunkypools.com/api/pool/exchange_rates/current", Api::Endpoint::Pool::ExchangeRates.current
    end
  end
end
