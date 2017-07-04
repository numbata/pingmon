require 'sinatra/base'
require_relative './icmp_manager'

class WebApiApp < Sinatra::Base
  set :bind, ENV["HOST"]

  get '/host/:host/statistic' do |host|
    content_type :json
    from = params[:from]
    to = params[:to]

    host = Host.find(host: params[:host])
    return status(404) unless host

    query = IcmpResult.by_host(host)
    query = query.from(from) if from
    query = query.to(from) if to

    result = query.overall_statistics.first.values

    content_type :json
    Oj.dump(result)
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
