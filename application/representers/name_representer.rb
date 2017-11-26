# frozen_string_literal: true

# Represents essential Repo information for API output
module TaiGo
  # Representer class for converting BusRoute attributes to json
  class NameRepresenter < Roar::Decorator
    include Roar::JSON

    property :english
    property :chinese
  end
end
