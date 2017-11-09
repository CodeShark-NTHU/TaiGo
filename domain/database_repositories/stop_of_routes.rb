# frozen_string_literal: true

module TaiGo
    module StopOfRoute
        # Repository for StopOfRoutes
        class StopOfRoutes
            
            # input : entity
            # use entity find stop of routes in stop_of_routes table
            def self.find(entity)
              find_stop_of_route(entity.sub_route_uid,entity.direction,entity.stop_uid,entity.stop_sequence)
            end
            
            def self.find_stop_of_route(sub_route_uid,direction,stop_uid,stop_sequence){
              db_record = Database::StopOfRouteOrm.first(sub_route_uid: sub_route_uid,direction: direction,uid: stop_uid,sequence: stop_sequence)
              rebuild_entity(db_record)
            }
            
        
            # return all entity
            def all
              Database::StopOfRouteOrm.all.map |db_stop_of_route|
                rebuild_entity(db_stop_of_route)
              }
            end


            # db -> entity
            def rebuild_entity(db_record)
              return nil unless db_record
              
        
              # rebuild entity
              Entity::StopOfRoute.new(
                sub_route_uid = db_record.sub_route_uid,
                direction = db_record.direction,
                stop_uid = db_record.uid,
                stop_sequence = db_record.sequence,
                stop_boarding = boarding,
              )
            end
            
            # entity -> db
            def self.create(entity) 
              raise 'StopOfRoute already exists in db' if find(entity)
              
              db_stop_of_route = Database::StopOfRouteOrm.create(
                sub_route_uid: entity.sub_route_uid,
                direction: entity.direction,
                uid: entity.stop_uid,
                sequence: entity.stop_sequence,
                boarding: entity.boarding,
              )
      
              rebuild_entity(db_stop_of_route)
      
            end
        end
    end
end
