# frozen_string_literal: false

require 'http'
require_relative 'city_stop.rb'
require_relative 'bus_stop.rb'

module PublicTrans
  # Library for MOTC Web API
  class MotcAPI
    module Errors
      class NotFound < StandardError; end
    end

    HTTP_ERROR = {
      500 => Errors::NotFound
    }.freeze

    def initialize(cache: {})
      @cache = cache
    end

    def stop(city_name)
      bus_stop_url = 'Stop/City/' + city_name
      city_st_req_url = most_api_path(bus_stop_url)
      city_st_data = call_most_url(city_st_req_url).parse
      CityStop.new(city_st_data, self)
    end

    def stop_list(data)
      data.map { |stop| BusStop.new(stop) }
    end

    private

    def most_api_path(path)
      'http://ptx.transportdata.tw/MOTC/v2/Bus/' + path
    end

    def call_most_url(url)
      result = @cache.fetch(url) do
        HTTP.get(url)
      end

      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.keys.include?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
