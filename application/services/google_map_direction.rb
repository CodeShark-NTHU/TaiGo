# frozen_string_literal: true

require 'dry/transaction'
require 'geocoder'

module TaiGo
  # Transaction to combine Google map direction with MOTC
  class GoogleMapDirection
    include Dry::Transaction
    step :check_range
    step :give_direction

    def check_range(input)
      s_r = in_the_range(input[:start_lat].to_f, input[:start_lng].to_f)
      d_r = in_the_range(input[:dest_lat].to_f, input[:dest_lng].to_f)
      if s_r && d_r
        start = "#{input[:start_lat]},#{input[:start_lng]}"
        dest = "#{input[:dest_lat]},#{input[:dest_lng]}"
        Right(direction: [start, dest])
      else
        Left(Result.new(:not_found, 'not in Hsinchu City'))
      end
    end

    def give_direction(input)
      start = input[:direction][0]
      dest = input[:direction][1]
      direction_mapper = TaiGo::GoogleMap::DirectionMapper.new(Api.config)
      directions = direction_mapper.load(start, dest)
      Right(Result.new(:ok, directions))
      # Right(Result.new(:ok, directions))
    rescue StandardError
      Left(Result.new(:not_found, 'please open your internet'))
    end

    def in_the_range(lat, lng)
      center = [24.778921686099686, 120.93383417011717]
      loc = [lat, lng]
      range_mile = 6.21
      dis = Geocoder::Calculations.distance_between(center,loc)
      dis <= range_mile ? true : false
    end
  end
end
