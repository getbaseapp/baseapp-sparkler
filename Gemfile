source :gemcutter

gem 'sinatra'

gem 'dm-core'
gem 'dm-migrations'
gem 'dm-timestamps'
gem 'haml'
gem 'warden-googleapps'

gem 'dm-postgres-adapter' unless ENV['SPARKLER']

if ENV['SPARKLER']
  gem 'dm-sqlite-adapter'
end
