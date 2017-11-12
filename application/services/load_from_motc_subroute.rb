# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load repo from Github and save to database
  class LoadFromMotcSubRoute
    def self.call(input)
      subroutes = TaiGo::MOTC::BusSubRouteMapper.new(input[:config]).load(input[:city_name])
    rescue StandardError
      routing.halt(404, error: "Bus Routes at #{input[:city_name]} not found")
    end
  end
end
