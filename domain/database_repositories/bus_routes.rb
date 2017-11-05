# frozen_string_literal: true

module TaiGo
    module Repository
        # Repository for BusRoutes Entities
        class BusRoutes
            def self.find_id(id)
                Database::BusStopOrm.first(id: id)&.rebuild_entity
            end

            def self.find_uid(uid)
                db_record = Database::BusRouteOrm.first(uid: uid)&.rebuild_entity
                rebuild_entity(db_record)
            end

            def self.find_or_create(entity)
                find_uid(entity.uid) || create_from(entity)
            end

            def self.rebuild_entity(db_record)
                return nil unless db_record
=begin        
                stops = db_record.stops.map do |db_stops|
                  BusStop.rebuild_entity(db_stops)
                end
=end       
                Entity::BusRoutes.new(
                    route_uid: db_record.uid,
                    authority_id: db_record.auth_id,
                    route_name: TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
                    depart_name: TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.depart_name_en,db_record.depart_name_zh),
                    destination_name: TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.destination_name_en,destination_name_zh),
                   
                )
              end
        end
    end
end
