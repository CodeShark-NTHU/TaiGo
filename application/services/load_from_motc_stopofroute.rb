# frozen_string_literal: true

require 'dry/transaction'

module TaiGo
  # Transaction to load repo from Github and save to database
  class LoadFromMotcStopOfRoute
    def self.call(input)
      stopofroutes = TaiGo::MOTC::StopOfRouteMapper.new(input[:config]).load(input[:city_name])
    rescue StandardError
      routing.halt(404, error: "Bus Routes at #{input[:city_name]} not found")
    end
  end
end
