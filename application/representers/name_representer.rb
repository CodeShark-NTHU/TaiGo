# frozen_string_literal: true

module TaiGo
  # Representer class for converting Name property to json
  class NameRepresenter < Roar::Decorator
    include Roar::JSON

    property :english
    property :chinese
  end
end
