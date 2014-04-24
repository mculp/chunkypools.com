class CoinPrice
  def self.current_exchange_rates
    Coin.active.map do |coin|
      { coin: coin, current_price: Price.current(coin)[:exchange_rate] }
    end
  end

  def self.yesterday_exchange_rates
    Coin.active.map do |coin|
      { coin: coin, yesterday_price: Price.retrieve(coin).yesterday_price }
    end
  end
end
