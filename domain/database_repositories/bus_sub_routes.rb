# frozen_string_literal: true

module TaiGo
    module Subroute
      # Repository for Subroutes
      class Subroutes
        
        # use id to find subroute 
        def self.find_id(id)
          db_record = Database::SubRouteOrm.first(id: id)
          rebuild_entity(db_record)
        end
        
        # use en_name to find subroute
        def self.find_en_name(name_en)
          db_record = Database::SubRouteOrm.first(name_en: name_en)
          rebuild_entity(db_record)
        end
        
         # use zh_name to find subroute
        def self.find_zh_name(name_zh)
          db_record = Database::SubRouteOrm.first(name_zh: name_zh)
          rebuild_entity(db_record)
        end
  
        def self.find_or_create(entity,route_uid)
          find_en_name(entity.name_en) || find_zh_name(entity.name_zh) || create(entity,route_uid)
        end
        
        # entity -> db
        def self.create(entity,route_uid)
          db_subroute = Database::SubRouteOrm.create(
            id: entity.sub_route_uid,
            route_id: route_uid,
            name_en: entity.sub_route_name.english,
            name_zh: entity.sub_route_name.chinese,
            headsign: entity.headsign,
            direction: direction
          )
          self.rebuild_entity(db_subroute)
        end
        
        # db -> entity
        def self.rebuild_entity(db_record)
          return nil unless db_record
  
          Entity::BusSubRoute.new(
            sub_route_uid: db_record.id,
            sub_route_name: TaiGo::MOTC::BusSubRouteMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
            headsign: db_record.headsign,
            direction: db_record.direction
          )
        end
      end
    end
  end