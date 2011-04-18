CartoDB::Settings = YAML.load(<<-YAML
host: 'https://api.cartodb.com'
oauth_key: '#{ENV['CARTODB_API_KEY']}'
oauth_secret: '#{ENV['CARTODB_API_SECRET']}'
YAML
)
CartoDB::Connection = CartoDB::Client::Connection.new