# frozen_string_literal: true

module TaiGo
  module Repository
    # Repository for Stops
    class Stops

      # use uid find stop in stop table
      def self.find_id(id)
        db_record = Database::StopOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.create_from(entity)
        db_collaborator = Database::StopOrm.create(
          id: entity.uid,
          name_zh: entity.name.chinese,
          name_en: entity.name.english,
          address: entity.address,
          latitude: entity.coordinates.latitude,
          longitude: entity.coordinates.longitude,
          auth_id: entity.auth_id
        )

      # entity -> db
      # def self.create(entity) 
      #   raise 'Stop already exists in db' if find(entity)
        
      #   db_stop = Database::StopOrm.create(
      #     id: entity.uid,
      #     name_en: entity.name.english,
      #     name_zh: entity.name.chinese,
      #     latitude: entity.coordinates.latitude,
      #     longitude: entity.coordinates.longitude,
      #     auth_id: entity.authority_id,
      #     address: entity.address,
      #   )
      #   rebuild_entity(db_stop)
      # end

      # return all stops in db to entity
      # def all
      #   Database::StopOrm.all.map |db_stop|
      #   rebuild_entity(db_stop)
      # end

      def self.rebuild_entity(db_record)
        return nil unless db_record
              
        # rebuild entity
        Entity::BusStop.new(
          uid: db_record.id,
          name: TaiGo::MOTC::BusStopMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
          coordinates: TaiGo::MOTC::BusStopMapper::DataMapper::Coordinates.new(db_record.latitude,db_record.longitude),
          authority_id: db_record.auth_id,
          address: db_record.auth_id
        )
      end
    end
  end
end
