module ApplicationHelper
  COINS = {
    'DOGE' =>  { pill_color: 'warning',  image: 'dogecoin120',     full_name: 'dogecoin' },
    'EAC'  =>  { pill_color: 'success',  image: 'earthcoin120',    full_name: 'earthcoin' },
    'RPC'  =>  { pill_color: 'danger',   image: 'ronpaulcoin120',  full_name: 'ronpaulcoin' },
    'LOT'  =>  { pill_color: 'warning',  image: 'lottocoin120',    full_name: 'lottocoin' },
    'SBC'  =>  { pill_color: 'danger',   image: 'stablecoin120',   full_name: 'stablecoin' },
    '42'   =>  { pill_color: 'default',  image: '42120',           full_name: '42' },
    'DGB'  =>  { pill_color: 'primary',  image: 'digibytewhite',   full_name: 'digibyte' },
    'KDC'  =>  { pill_color: 'primary',  image: 'klondikewhite',   full_name: 'klondikecoin' },
    'LTC'  =>  { pill_color: 'default',  image: 'litecoin120',     full_name: 'litecoin' },
    'RUBY' =>  { pill_color: 'danger',   image: 'rubycoin120',     full_name: 'rubycoin' },
    'POT'  =>  { pill_color: 'success',  image: 'potcoin120',      full_name: 'potcoin' },
    'SUN'  =>  { pill_color: 'warning',  image: 'suncoin120',      full_name: 'suncoin' },
    'RON'  =>  { pill_color: 'danger',   image: 'swansoncoin120',      full_name: 'ronswansoncoin' },
    'AUR'  =>  { pill_color: 'success',  image: 'auroracoin120',   full_name: 'auroracoin' },
    'FLAP' =>  { pill_color: 'warning',  image: 'flappycoin120',   full_name: 'flappycoin' },
    'PCN' =>   { pill_color: 'primary',  image: 'procoin120',   full_name: 'procoin' },
    'RUBY' =>  { pill_color: 'danger',   image: 'rubycoin120',     full_name: 'rubycoin' },
    'SPN' =>   { pill_color: 'default',   image: 'spartancoin120',     full_name: 'spartancoin' },
    'DEF' =>   { pill_color: 'success',   image: 'defcoin120',     full_name: 'defcoin' },
    'STP' =>   { pill_color: 'default',   image: 'stoopidcoin120',     full_name: 'stoopidcoin' },
    'MUN' =>   { pill_color: 'success',   image: 'muniti120',     full_name: 'muniti' }
  }

  def pool(coin)
    Rails.logger.info @pool_info.pools.inspect
    Rails.logger.info coin.inspect
    @pool_info.pools.find { |pool| pool.coin == coin }
  end

  def fastest_pool
    @pool_info.pools.find { |pool| pool.coin == @pool_info.best_hash_rate }.hash_rate
  end

  def most_popular_pool
    @pool_info.pools.find { |pool| pool.coin == @pool_info.most_workers }.number_of_workers
  end

  def time_since_last_block(coin)
    pool(coin).time_since_last_block 
  end

  def arrows
    older = @raw_results.first

    old_workers = older['pools'].find { |pool| pool['coin'] == @pool_info.most_workers }['number_of_workers']
    old_hashrate = older['pools'].find { |pool| pool['coin'] == @pool_info.best_hash_rate }['hash_rate']

    [
      @pool_info.hash_rate > older['hash_rate'],
      fastest_pool > old_hashrate,
      @pool_info.workers > older['workers'],
      most_popular_pool > old_workers
    ].map do |cond|
      cond ? "fa-caret-up color-green" : "fa-caret-down color-red"
    end
  end

  def coin_link(coin)
    link_to "#{chunky_url}#{coin}" do
      yield
    end
  end

  def coin_image(coin, options = {})
    image_tag("#{COINS[coin.upcase][:image]}.png", options)
  end

  def coin_full_name(coin)
    COINS[coin.upcase][:full_name]
  end

  def coin_port(coin)
    Coin.active.find { |c| c.code == coin.downcase }.port
  end

  def label_for(coin)
    COINS[coin.upcase][:pill_color]
  end

  # <li><a href="/contact"><i class="fa fa-inbox"></i> Contact</a></li>
  def nav_item(text, link, icon, active_condition = nil)
    active = { class: 'active' } if active_condition && content_for(:page) == active_condition
    content_tag(:li, active) do
      link_to(content_tag(:i, nil, class: "fa fa-#{icon}") + ' ' + text, link)
    end
  end

  def nav_spacer
    content_tag(:li) { raw("&nbsp;") }
  end
end
