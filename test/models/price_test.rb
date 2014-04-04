require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  test "determine_source will correctly find mintpal coins" do
    assert_equal Source::Mintpal, Price.determine_source(coins(:suncoin))
  end

  test "determine_source will default to cryptocoincharts" do
    assert_equal Source::Cryptocoincharts, Price.determine_source(coins(:ronpaulcoin))
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

