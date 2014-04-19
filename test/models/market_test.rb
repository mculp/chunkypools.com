require 'test_helper'

class MarketTest < ActiveSupport::TestCase
  def setup
    @market = Market.by_name(:bittrex)
    @json = @market.to_json
    @parsed_json = JSON.parse(@json)
  end

  test "by_name will return the correct object" do
    assert Market::Bittrex === @market
  end

  test "it will correctly grab the market's name" do
    assert_equal 'bittrex', @market.name
  end

  test "it serializes in the correct format" do
    assert_equal 'bittrex', @parsed_json['name']
    assert Array === @parsed_json['pairs']

    first_pair = @parsed_json['pairs'].first

    assert first_pair['quote'].present?
    assert first_pair['base'].present?

    assert "#{first_pair['quote']}/#{first_pair['base']}", first_pair['name']

    assert first_pair.has_key? 'volume'
    assert first_pair.has_key? 'high'
    assert first_pair.has_key? 'low'
    assert first_pair['last'].present?
    assert String === first_pair['last']
  end

  test "quote can have a dash in it" do
    pair_with_dash = @market.pairs.find { |pair| pair.pair_data['MarketName'].count("-") > 1 }

    assert pair_with_dash.quote.count("-") > 0
  end

  test "it correctly reads all markets" do
    assert_send [Market.market_list, :include?, 'bittrex']
    assert_send [Market.market_list, :include?, 'mintpal']
    assert_send [Market.market_list, :include?, 'cryptocoincharts']

    assert Market.market_list.none? { |item| item == 'pair' }
  end

  test "it correctly serializes all markets" do
    @all = Market.all

    bittrex = @all.find { |a| a.name == 'bittrex' }
    mintpal = @all.find { |a| a.name == 'mintpal' }
    cryptocoincharts = @all.find { |a| a.name == 'cryptocoincharts' }

    assert_not_nil bittrex
    assert_not_nil mintpal
    assert_not_nil cryptocoincharts

    assert bittrex.pairs.present?
    assert mintpal.pairs.present?
    assert cryptocoincharts.pairs.present?

    assert bittrex.pairs.first.name =~ /^.+\/BTC$/
    assert mintpal.pairs.first.name =~ /^.+\/BTC$/
    assert cryptocoincharts.pairs.first.name =~ /^.+\/BTC$/

    assert bittrex.pairs.first.last.present?
    assert mintpal.pairs.first.last.present?
    assert cryptocoincharts.pairs.first.last.present?
  end
end
