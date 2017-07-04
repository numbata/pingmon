require 'sinatra/base'
require 'icmp_manager'

class WebApiApp < Sinatra::Base
  set :bind, ENV["HOST"]

  get '/status' do
    "OK"
  end

  post '/watch' do
    host = params['host']

    return status(422) unless host
    return status(409) if IcmpManager.watched?(host)

    IcmpManager.watch(host)
    status 201
  end

  delete '/watch/:host' do |host|
    return status(404) unless IcmpManager.watched?(host)

    IcmpManager.unwatch(host)
    status 204
  end
end
