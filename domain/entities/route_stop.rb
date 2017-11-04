# frozen_string_literal: false

require 'dry-struct'
require_relative 'contributor.rb'

module TaiGo
  module Entity
    # Domain entity object for RouteStop
    class RouteStop < Dry::Struct
      attribute :stop_uid, Types::Strict::String
      attribute :stop_id, Types::Strict::String.optional
      attribute :stop_name_ch, Types::Strict::String
      attribute :stop_name_en, Types::Strict::String.optional
      attribute :stop_boarding, Types::Strict::Int
      attribute :stop_sequence, Types::Strict::Int
      attribute :stop_latitude, Types::Strict::Float
      attribute :stop_longitude, Types::Strict::Float
      attribute :stops, Types::Strict::Array.member(Stops)
    end
  end
end
