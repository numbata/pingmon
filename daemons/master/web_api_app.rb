require 'sinatra/base'

class WebApiApp < Sinatra::Base
  set :bind, ENV["HOST"]

  get '/status' do
    "OK"
  end

  post '/watch' do
    return status(422) unless params['ip']
    MasterApiClient.watch(params['ip'])

    status 201
  end

  delete '/watch/:ip' do |ip|
    MasterApiClient.unwatch(params['ip'])

    status 204
  end
end
