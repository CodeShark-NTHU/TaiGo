require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for git BusStop
    class BusStop < Dry::Struct
      attribute :uid, Types::Strict::String
      attribute :authority_id, Types::Strict::String
      attribute :stop_name_ch, Types::Strict::String
      attribute :stop_name_en, Types::Strict::String.optional
      attribute :stop_latitude, Types::Strict::Float
      attribute :stop_longitude, Types::Strict::Float
      attribute :stop_address, Types::Strict::String.optional
    end
  end
end
