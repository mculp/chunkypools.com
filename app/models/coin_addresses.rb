module CoinAddresses
  def for(coin)
    find { |item| item.coin.downcase == coin.downcase } 
  end  
end