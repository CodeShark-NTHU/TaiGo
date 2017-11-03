# frozen_string_literal: false

require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for git BusRoute
    class BusRoute < Dry::Struct
      attribute :route_uid, Types::Int.optional
      attribute :route_name_zh, Types::Strict::String
      attribute :route_name_en, Types::Strict::String
      attribute :authority_id, Types::Int.optional
      attribute :depart_stop_name_zh, Types::Strict::String
      attribute :depart_stop_name_en, Types::Strict::String.optional
      attribute :dest_stop_name_zh, Types::Strict::String
      attribute :dest_stop_name_en, Types::Strict::String.optional
    end
  end
end
