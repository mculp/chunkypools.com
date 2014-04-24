require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  def setup
    summary_contents = File.read(File.dirname(__FILE__) + "/../fixtures/responses/market_summary.json")
    @market_summary = Hashie::Mash.loose(JSON.parse(summary_contents))

    @no_exchange_coin = Coin['def']
    @one_exchange_coin = Coin['dgb']
    @two_exchange_coin = Coin['doge']
    @three_exchange_coin = Coin['pot']
  end

  test "will return 0 for a coin from a market summary with 0 exchanges listed" do
    rate = Price.max_exchange_rate_from_market_summary(@market_summary, @no_exchange_coin)
    assert_equal 0, rate
  end

  test "will get the price for a coin from a market summary with 1 exchange listed" do
    rate = Price.max_exchange_rate_from_market_summary(@market_summary, @one_exchange_coin)
    assert_equal 0.00000042, rate
  end

  test "will get the max price for a coin from a market summary with 2 exchange listed" do
    rate = Price.max_exchange_rate_from_market_summary(@market_summary, @two_exchange_coin)
    assert_equal 0.00000124, rate
  end

  test "will get the max price for a coin from a market summary with 3 exchange listed" do
    rate = Price.max_exchange_rate_from_market_summary(@market_summary, @three_exchange_coin)
    assert_equal 0.00001799, rate
  end

  class MintpalTest < ActiveSupport::TestCase
    def setup
      @subject = Source::Mintpal.new(coins(:suncoin))
      @subject.parsed_body = response_from(:mintpal, coin: 'suncoin')
    end

    test "coin code will get substituted into url correctly" do
      url = "https://api.mintpal.com/market/stats/SUN/BTC"
      assert_equal url, @subject.url
    end

    test "current_price will be correctly parsed" do
      assert_equal 0.00001000, @subject.current_price
    end

    test "yesterday_price will be correctly parsed" do
      assert_equal 0.00003750, @subject.yesterday_price
    end
  end

  class CryptocoinchartsTest < ActiveSupport::TestCase
    def setup
      @subject = Source::Cryptocoincharts.new(coins(:ronpaulcoin))
      @subject.parsed_body = response_from(:cryptocoincharts, coin: 'ronpaulcoin')
    end

    test "coin code will get substituted into url correctly" do
      url = "http://www.cryptocoincharts.info/v2/api/tradingPair/rpc_btc"
      assert_equal url, @subject.url
    end

    test "current_price will be correctly parsed" do
      assert_equal 0.00116095, @subject.current_price
    end

    test "yesterday_price will be correctly parsed" do
      assert_equal 0.00110000, @subject.yesterday_price
    end
  end
end

