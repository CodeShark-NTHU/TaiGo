# frozen_string_literal: false

require 'http'
require_relative 'city_stops.rb'
require_relative 'bus_stop.rb'

module PublicTransporation
  module Errors
    # Not allowed to access resource
    ServerError = Class.new(StandardError)
    # Requested resource not found
    NotFound = Class.new(StandardError)
  end

  # Library for MOTC Web API
  class MotcAPI

    # Encapsulates API response success and errors
    class Response  
      HTTP_ERROR = {
        500 => Errors::ServerError,
        404 => Errors::NotFound
      }.freeze

      def initialize(response)
        @response = response
      end

      def successful?
        HTTP_ERROR.keys.include?(@response.code) ? false : true
      end

      def response_or_error
        successful? ? @response : raise(HTTP_ERROR[@response.code])
      end
    end
    
    def initialize(cache: {})
      @cache = cache
    end

    def stop(city_name)
      city_st_req_url = MotcAPI.path(['Stop','City',city_name].join("/"))
      city_st_data = call_most_url(city_st_req_url).parse
      CityStops.new(city_st_data, self)
    end

    def stop_list(data)
      data.map { |stop| BusStop.new(stop) }
    end

    def self.path(path)
      'http://ptx.transportdata.tw/MOTC/v2/Bus/' + path
    end

    private

    def call_most_url(url)
      response = @cache.fetch(url) do
        HTTP.get(url)
      end
      Response.new(response).response_or_error
    end

  end
end
