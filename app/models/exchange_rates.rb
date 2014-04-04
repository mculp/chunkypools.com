module ExchangeRates
  def for(coin)
    find { |item| item[:coin][:code].downcase == coin.downcase } 
  end
end