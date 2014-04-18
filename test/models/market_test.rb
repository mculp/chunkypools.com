require 'test_helper'

class MarketTest < ActiveSupport::TestCase
  def setup
    @market = Market.by_name(:bittrex)
  end

  test "by_name will return the correct object" do
    assert Market::Bittrex === @market
  end

  test "it will correctly grab the market's name" do
    assert_equal 'bittrex', @market.name
  end

  test "it serializes in the correct format" do
    json = @market.to_json
    parsed_json = JSON.parse(json)

    assert_equal 'bittrex', parsed_json['name']
    assert Array === parsed_json['pairs']

    first_pair = parsed_json['pairs'].first

    assert first_pair['quote'].present?
    assert first_pair['base'].present?

    assert "#{first_pair['quote']}/#{first_pair['base']}", first_pair['name']

    assert first_pair.has_key? 'volume'
    assert first_pair.has_key? 'high'
    assert first_pair.has_key? 'low'
    assert first_pair['last'].present?
  end
end
