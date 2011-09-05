require 'resque'

ENV["REDISTOGO_URL"] ||= "redis://localhost:6379/"
ENV['QUEUE'] ||= '*'

uri = URI.parse( ENV["REDISTOGO_URL"] )
Resque.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)

Resque.inline = (Rails.env.test? || Rails.env.cucumber?)
