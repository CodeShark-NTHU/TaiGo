require 'dry-struct'

module TaiGo
  module Entity
    # Domain entity object for git BusStop
    class BusStop < Dry::Struct
      attribute :uid, Types::Strict::String
      attribute :authority_id, Types::Strict::String
      attribute :name, Types::Strict::Object
      attribute :address, Types::Strict::String.optional
    end
  end
end
