require_relative '../core/common.rb'
require_relative 'api_app.rb'

STDOUT.sync = true

Rack::Handler::Thin.run ApiApp.new,
  Port: ENV['API_PORT'] || 8080,
  Host: ENV['API_HOST'] || '0.0.0.0'
