# frozen_string_literal: false

require 'dry-struct'
require_relative 'stop_of_route.rb'

module TaiGo
  module Entity
    # Domain entity object for StopsOfSubRoute
    class StopsOfSubRoute < Dry::Struct
      attribute :stops_of_sub_route, Types::Strict::Array.member(StopOfRoute)
    end
  end
end
