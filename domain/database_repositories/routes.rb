# frozen_string_literal: true

module TaiGo
  module Repository
    # Repository for Routes
    class Routes
      def self.find_id(id)
        db_record = Database::RouteOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_name_ch(name_zh)
        db_record = Database::RouteOrm.first(name_zh: name_zh)
        puts db_record
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find_id(entity.id) || create_from(entity)
      end

      def self.create_from(entity)
        # raise 'Route already exists in db' if find(entity)

        Database::RouteOrm.unrestrict_primary_key
        db_route = Database::RouteOrm.create(
          id: entity.id,
          name_en: entity.name.english,
          name_zh: entity.name.chinese,
          dep_en: entity.depart_name.english,
          dep_zh: entity.depart_name.chinese,
          dest_en: entity.destination_name.english,
          dest_zh: entity.destination_name.chinese,
          auth_id: entity.authority_id
        )

        # insert to subroute db
        # entity.sub_routes.each do |sub_route|
          # stored_sub_route = SubRoutes.find_or_create(sub_route,
                                                      # entity.route_uid)
          # sroute = Database::SubRouteOrm.first(id: stored_sub_route.id)
          # db_route.add_sub_routes(sroute)
        # end

        rebuild_entity(db_route)
      end

      # db -> entity
      def self.rebuild_entity(db_record)
        return nil unless db_record

        sub_routes = []

        sub_routes = db_record.sub_routes.map do |db_sroutes|
          SubRoutes.rebuild_entity(db_sroutes)
        end

        Entity::BusRoute.new(
          id: db_record.id,
          name: TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
          depart_name: TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.dep_en,db_record.dep_zh),
          destination_name: TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.dest_en,db_record.dest_zh),
          authority_id: db_record.auth_id,
          owned_sub_routes: sub_routes
        )
      end

      # def self.find(entity)
      #   find_route_uid(entity.route_uid)
      # end

      # return all rotues in db to entity
      # def all
      #   Database::RouteOrm.all.map |db_route|
      #   rebuild_entity(db_route)
      # end
    end
  end
end
