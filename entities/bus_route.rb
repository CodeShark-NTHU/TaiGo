require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for git BusRoute
    class BusRoute < Dry::Struct
      attribute :route_uid, Types::Strict::String
      attribute :authority_id, Types::Strict::String
      attribute :route_name,  Types::Strict::Object
      attribute :depart_name, Types::Strict::Object
      attribute :destination_name, Types::Strict::Object
    end
  end
end
