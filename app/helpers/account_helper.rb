module AccountHelper
  def btc_value(balance)
    (balance[:confirmed].to_f + balance[:unconfirmed].to_f) * @exchange_rates.for(balance[:coin]).current_price
  end

  def balance_display(balance)
    if balance
      balance = 0 if balance < 0

      "%.8f" % balance
    else
      "err"
    end
  end
end
