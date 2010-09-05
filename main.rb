require 'rubygems'
require 'sinatra'

require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'haml'

configure :development do
  require 'dm-sqlite-adapter'
end

configure :production do
  require 'dm-postgres-adapter'
end

require 'auth'

class Hash
  def rename(old_to_new)
    old_to_new.each do |old, new|
      self[new] = self.delete(old)
    end

    self
  end
end

class Sparkle
  include DataMapper::Resource

  property 'id',           Serial
  property 'created_at',   DateTime
  property 'appName',      String
  property 'appVersion',   String
  property 'compModel',    String
  property 'cpu64bit',     Boolean
  property 'cpuFreqMHz',   Integer
  property 'cpusubtype',   String
  property 'cputype',      String
  property 'lang',         String
  property 'ncpu',         Integer
  property 'ramMB',        Integer
end

configure do
  DataMapper.setup(:default, (ENV["DATABASE_URL"] ||  "sqlite3://#{Dir.pwd}/sparkle.sqlite"))
  DataMapper.auto_upgrade!
end

get '/' do
  'This is the CloudApp updates suite, we are making it pretty, don\'t worry.'
end

get '/update.xml' do
  begin
    unless params.empty?
      Sparkle.new(request.params.clone.rename('model' => 'compModel')).save
    end
  rescue Exception

  ensure
    redirect '/feed.xml'
  end
end

get '/feed.xml' do
  response.headers['Cache-Control'] = 'public, max-age=31557600'

  File.read('public/feed.xml')
end

get '/admin' do
  ensure_authenticated

  @sparkles = Sparkle.all

  haml :admin
end
