# frozen_string_literal: true

module TaiGo
    module Database
      # Object Relational Mapper for BusStop Entities
      class StopsOfRoutesOrm < Sequel::Model(:stops_of_routes)
    
  
        plugin :timestamps, update_on_create: true
      end
    end
  end
  