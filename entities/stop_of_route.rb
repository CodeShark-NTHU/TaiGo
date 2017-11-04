# frozen_string_literal: false

require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for git BusStop
    class StopOfRoute < Dry::Struct
      attribute :stop_uid, Types::Strict::String
      attribute :sub_route_uid, Types::Strict::String.optional
      attribute :direction, Types::Strict::Int
      attribute :stops, Types::Strict::Array.member(Stops)      
    end
  end
end
