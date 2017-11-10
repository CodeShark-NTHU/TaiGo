# frozen_string_literal: true

module TaiGo
  module Repository
    # Repository for Subroutes
    class Subroutes
      def self.find_id(id)
        db_record = Database::SubRouteOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity, route_id)
        find_id(entity.sub_route_id) || create_from(entity, route_id)
      end

      # def sub_routes_list(route_id)
      #   db_record = Database::SubRouteOrm.where(route_id: route_id).all
      # end

      def self.create_from(entity, route_id)
        db_subroute = Database::SubRouteOrm.create(
          id: entity.sub_route_uid,
          route_id: route_id,
          name_zh: entity.sub_route_name.chinese,
          name_en: entity.sub_route_name.english,
          headsign: entity.headsign,
          direction: entity.direction
        )

        rebuild_entity(db_subroute)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::BusSubRoute.new(
          sub_route_uid: db_record.id,
          route_id: db_record.route_id,
          sub_route_name: TaiGo::MOTC::BusSubRouteMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
          headsign: db_record.headsign,
          direction: db_record.direction
        )
      end
    end
  end
end
