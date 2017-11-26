# frozen_string_literal: true

module TaiGo
  module Repository
    # Repository for Subroutes
    class SubRoutes
      def self.find_id(id)
        db_record = Database::SubRouteOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find_id(entity.id) || create_from(entity)
      end

      def self.create_from(entity)
        Database::SubRouteOrm.unrestrict_primary_key
        db_subroute = Database::SubRouteOrm.create(
          id: entity.id,
          route_id: entity.route_id,
          name_zh: entity.name.chinese,
          name_en: entity.name.english,
          headsign: entity.headsign,
          direction: entity.direction
        )

        rebuild_entity(db_subroute)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record
        stop_of_routes = []
        stop_of_routes = db_record.stop_of_routes.map do |stop_of_route|
          StopOfRoutes.rebuild_entity(stop_of_route)
        end

        Entity::BusSubRoute.new(
          id: db_record.id,
          route_id: db_record.route_id,
          name: TaiGo::MOTC::BusSubRouteMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
          headsign: db_record.headsign,
          direction: db_record.direction,
          owned_stop_of_routes: stop_of_routes
        )
      end
    end
  end
end
