# frozen_string_literal: false

require 'http'
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
    # Encapsulates API Requests
    class Request
      def initialize(path, cache = {})
        @path = path
        @cache = cache
      end

      def url
        'http://ptx.transportdata.tw/MOTC/v2/Bus/' + @path
      end

      def execute
        response = @cache.fetch(url) { HTTP.get(url) }
        Response.new(response).response_or_error
      end
    end

    def initialize(cache: {})
      @cache = cache
    end

    def city_bus_stops(city_name)
      request = Request.new(%W[Stop City #{city_name}].join('/'), @cache)
      response = request.execute.parse
      MotcAPI.stop_list(response)
    end

    def self.stop_list(data)
      data.map { |stop| BusStop.new(stop) }
    end
  end
end
