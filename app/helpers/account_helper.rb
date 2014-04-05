module AccountHelper
  def btc_value(balance)
    (balance[:confirmed].to_f + balance[:unconfirmed].to_f) * @exchange_rates.for(balance[:coin]).current_price 
  end
end
