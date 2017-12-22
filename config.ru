# frozen_string_literal: true

require_relative './init.rb'
#require 'rack/cors'
run TaiGo::Api.freeze.app
=begin
use Rack::Cors do
  allow do
    origins 'localhost:4000', '127.0.0.1:4000',
            /\Ahttp:\/\/192\.168\.0\.\d{1,3}(:\d+)?\z/
            # regular expressions can be used here

    resource '/file/list_all/', :headers => 'x-domain-token'
    resource '/file/at/*',
        :methods => [:get, :post, :delete, :put, :patch, :options, :head],
        :headers => 'x-domain-token',
        :max_age => 600
        # headers to expose
  end

  allow do
    origins '*'
    resource '/public/*', :headers => :any, :methods => :get
  end
end
=end