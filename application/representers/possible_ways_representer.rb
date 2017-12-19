# frozen_string_literal: true

require_relative 'possible_way_representer'

module TaiGo
  # Representer class for converting Bus Positions attributes to json
  class PossibleWaysRepresenter < Roar::Decorator
    include Roar::JSON
    collection :possibleways, extend: PossibleWayRepresenter, class: OpenStruct
  end
end
