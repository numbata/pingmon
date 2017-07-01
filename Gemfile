source 'https://rubygems.org'

ruby "2.4"

gem 'eventmachine'
gem 'icmp4em', github: 'krakatoa/icmp4em', ref: '0adcd51c57c328bb975daa4916ed8e5debc96a22'
gem 'em-pg-client', '~> 0.3.4'
gem 'websocket-eventmachine-server'
gem 'websocket-eventmachine-client'
gem 'sinatra'
gem 'thin'
gem 'sequel'
gem 'oj'
gem 'oj_mimic_json'
gem 'multi_json'

group :development do
  gem 'rake'
  gem 'foreman'
end

group :test do
  gem 'mocha', require: false
  gem 'minitest'
  gem 'rack-test'
  gem 'fakeweb'
end
