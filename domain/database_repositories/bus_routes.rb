# frozen_string_literal: true

module TaiGo
    module Route
        # Repository for Routes
        class Routes
            
            # input : entity
            # use entity find route in routes table
            def self.find(entity)
              find_route_uid(entity.route_uid)
            end
            
            def self.find_route_uid(route_uid){
              db_record = Database::RouteOrm.first(id: route_uid)
              rebuild_entity(db_record)
            }
            
            # use route_uid find route in route table
            def self.find_id(route_uid)
              db_record = Database::RouteOrm.first(id: route_uid)
              rebuild_entity(db_record)
            end
        
            # return all rotues in db to entity
            def all
              Database::RouteOrm.all.map |db_route|
                rebuild_entity(db_route)
              }
            end

            def sub_routes_list(route_id)
              db_record = Database::SubRouteOrm.where(route_id: route_id).all
            end

            # db -> entity
            def rebuild_entity(db_record)
              return nil unless db_record
              
              sub_routes_entity = sub_routes_list(db_record.id).map do |db_sub_route|
                SubRoutes.rebuild_entity(db_sub_route)
              end
              # rebuild entity
              Entity::BusRoute.new(
                route_uid = db_record.id,
                route_name = TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.name_en,db_record.name_zh),
                depart_name = TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.dep_en,db_record.dep_zh),
                destination_name = TaiGo::MOTC::BusRouteMapper::DataMapper::Name.new(db_record.dest_en,db_record.dest_zh),
                authority_id = auth_id,
                sub_routes = sub_routes_entity
              )
            end
            
            # entity -> db
            def self.create(entity) 
              raise 'Route already exists in db' if find(entity)
              
              db_route = Database::RouteOrm.create(
                id: entity.route_uid,
                name_en: entity.route_name.english,
                name_zh: entity.route_name.chinese,
                dep_en: entity.depart_name.english,
                dep_zh: entity.depart_name.chinese,
                dest_en: entity.destination_name.english,
                dest_zh: entity.destination_name.chinese,
                auth_id: entity.authority_id,
              )
              #insert to subroute db
              entity.sub_routes.each do |sub_route|
                stored_sub_route = SubRoutes.find_or_create(sub_route,entity.route_uid)
                sroute = Database::SubRoutesOrm.first(id: stored_sub_route.id)
              end
      
              rebuild_entity(db_route)
      
            end
        end
    end
end
