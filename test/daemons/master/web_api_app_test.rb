require 'test_helper'
require 'rack/test'
require 'web_api_app'

describe WebApiApp do
  before(:all) do
    @browser = Rack::Test::Session.new(Rack::MockSession.new(WebApiApp))
  end

  it 'should start watching' do
    host = generate :ip_address
    IcmpManager.stub :watched?, false do
      @browser.post '/watch', host: host
    end

    assert { @browser.last_response.created? }
  end

  it 'shouldn\'t start watching' do
    host = generate :ip_address
    IcmpManager.stub :watched?, true do
      @browser.post '/watch', host: host
    end

    assert { @browser.last_response.status == 409 }
  end

  it 'should stop watching' do
    host = generate :ip_address
    IcmpManager.stub :watched?, true do
      @browser.delete "/watch/#{host}"
    end

    assert { @browser.last_response.no_content? }
  end

  it 'shouldn\'t stop watching' do
    host = generate :ip_address
    IcmpManager.stub :watched?, false do
      @browser.delete "/watch/#{host}"
    end

    assert { @browser.last_response.not_found? }
  end

  it 'should get host statistic' do
    host = create :host
    period = create :icmp_period, host: host, started_at: Time.now
    create_list :icmp_result, 10, host: host, icmp_period: period, status: :success

    @browser.get "/host/#{host.host}/statistic"
    assert { @browser.last_response.ok? }
  end
end
