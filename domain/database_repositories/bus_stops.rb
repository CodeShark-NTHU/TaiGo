# frozen_string_literal: true

module TaiGo
    module Repository
        # Repository for BusStop Entities
        class BusStops
            def self.find_id(id)
                Database::BusStopOrm.first(id: id)&.rebuild_entity
            end

            def self.find_uid(uid)
                db_record = Database::BusStopOrm.first(uid: uid)&.rebuild_entity
                rebuild_entity(db_record)
            end

            def self.find_or_create(entity)
                find_uid(entity.uid) || create_from(entity)
            end

            def self.create_from(entity)
                db_stop = Database::BusStopOrm.create(
                  uid: entity.uid,
                  name_en: entity.name.english,
                  name_zh: entity.name.chinese,
                  lat: entity.coordinates.latitude,
                  lng: entity.coordinates.longitude,
                  auth_id: entity.authority_id
                )
        
                self.rebuild_entity(db_stop)
              end

            def self.rebuild_entity(db_record)
                return nil unless db_record
        
                Entity::BusStop.new(
                    uid: db_record.uid,
                    authority_id: db_record.auth_id,
                    name: TaiGo::MOTC::BusStopMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
                    coordinates: TaiGo::MOTC::BusStopMapper::DataMapper::Coordinates.new(db_record.lat,db_record.lng),
                    #address: db_record.address
                  )
              end
            
        end
    end
end