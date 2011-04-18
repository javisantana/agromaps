CartoDB::Settings = {
  'host'         => 'https://api.cartodb.com',
  'oauth_key'    => ENV['AGROMAPS_CARTODB_KEY'],
  'oauth_secret' => ENV['AGROMAPS_CARTODB_SECRET']
}

CartoDB::Connection = CartoDB::Client::Connection.new