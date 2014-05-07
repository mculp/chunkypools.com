module CoinConfig
  MULTIPOOL_CONTAINER = [
    Coin.new(
      name: 'Whitecoin',
      code: 'wc',
      multi: true,
      reward: 30000,
      label_color: 'default',
      port: { scrypt: 3337, sha256: 4477, x11: 1177 },
      price_sources: ['mintpal', 'bittrex', 'cryptocoincharts']),

    Coin.new(
      name: 'Summercoin',
      code: 'sum',
      multi: true,
      reward: 30000,
      label_color: 'success',
      port: 1137,
      price_sources: ['mintpal', 'bittrex', 'cryptocoincharts']),

    Coin.new(
      name: 'Bonuscoin',
      code: 'bns',
      multi: true,
      reward: 30000,
      active: false,
      label_color: 'warning',
      port: 3357,
      price_sources: ['bittrex', 'cryptocoincharts'])
  ]

  SHA256_CONTAINER = [
    Coin.new(
      name: 'Terracoin',
      code: 'trc',
      algorithm: 'sha256',
      reward: 20,
      label_color: 'warning',
      port: 4444,
      price_sources: ['bittrex', 'cryptocoincharts'])
  ]

  SCRYPT_CONTAINER = [
    Coin.new(
      name: 'Bitstar',
      code: 'bits',
      reward: 124,
      active: false,
      label_color: 'warning',
      port: 3341,
      price_sources: ['bittrex', 'cryptocoincharts']),

    Coin.new(
      name: 'Defcoin',
      code: 'def',
      reward: 50,
      label_color: 'success',
      port: 3349,
      price_sources: []),

    Coin.new(
      name: 'Digibyte',
      code: 'dgb',
      reward: 8000,
      active: false,
      label_color: 'primary',
      port: 3340,
      price_sources: ['mintpal']),

    Coin.new(
      name: 'Dogecoin',
      code: 'doge',
      reward: 125000,
      label_color: 'warning',
      port: 3333,
      price_sources: ['mintpal', 'bittrex']),

    Coin.new(
      name: 'Karmacoin',
      code: 'karm',
      reward: 110000,
      label_color: 'primary',
      port: 3339,
      price_sources: ['bittrex']),

    Coin.new(
      name: 'Kashmircoin',
      code: 'ksc',
      reward: 0.001001,
      label_color: 'warning',
      port: 3338,
      price_sources: ['bittrex', 'cryptocoincharts']),

    Coin.new(
      name: 'Potcoin',
      code: 'pot',
      reward: 420,
      port: 3420,
      label_color: 'success',
      price_sources: ['mintpal', 'bittrex', 'cryptocoincharts']),

    Coin.new(
      name: 'RonPaulCoin',
      code: 'rpc',
      reward: 1,
      port: 3335,
      label_color: 'danger',
      price_sources: ['cryptocoincharts'],
      source_attribute: :name),

    Coin.new(
      name: 'Rubycoin',
      code: 'ruby',
      reward: 250,
      port: 3342,
      label_color: 'danger',
      price_sources: ['cryptocoincharts']),

    Coin.new(
      name: 'Spartancoin',
      code: 'spn',
      reward: 150000,
      port: 3348,
      label_color: 'default',
      price_sources: ['bittrex', 'cryptocoincharts'])
  ]

  X11_CONTAINER = [
    Coin.new(
      name: 'Muniti',
      code: 'mun',
      algorithm: 'x11',
      reward: 39,
      label_color: 'success',
      port: 1133,
      price_sources: ['bittrex', 'cryptocoincharts'])
  ]

  CONTAINER = MULTIPOOL_CONTAINER + SHA256_CONTAINER + SCRYPT_CONTAINER + X11_CONTAINER
end
