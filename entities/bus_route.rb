require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for git BusRoute
    class BusRoute < Dry::Struct
      attribute :route_uid, Types::Strict::String
      attribute :route_name_zh, Types::Strict::String
      attribute :route_name_en, Types::Strict::String
      attribute :authority_id, Types::Strict::String
      attribute :depart_stop_name_zh, Types::Strict::String
      attribute :depart_stop_name_en, Types::Strict::String.optional
      attribute :dest_stop_name_zh, Types::Strict::String
      attribute :dest_stop_name_en, Types::Strict::String.optional
    end
  end
end
