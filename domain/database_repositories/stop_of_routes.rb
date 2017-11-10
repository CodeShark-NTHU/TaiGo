# frozen_string_literal: true

module TaiGo
  module Repository
    # Repository for StopOfRoutes
    class StopOfRoutes
      def self.find_stop_of_route(sub_route_uid, stop_uid, sequence)
        db_record = Database::StopOfRouteOrm.first(sub_route_uid: sub_route_uid,
                                                   stop_uid: stop_uid,
                                                   sequence: sequence)
        rebuild_entity(db_record)
      end

      # # return all entity
      # def all
      #   Database::StopOfRouteOrm.all.map do |db_stop_of_route|
      #   rebuild_entity(db_stop_of_route)
      # end

      def self.create(entity)
        # raise 'StopOfRoute already exists in db' if find(entity)

        db_stop_of_route = Database::StopOfRouteOrm.create(
          sub_route_uid: entity.sub_route_uid,
          stop_uid: entity.stop_uid,
          sequence: entity.stop_sequence,
          boarding: entity.boarding
        )

        rebuild_entity(db_stop_of_route)
      end

      def rebuild_entity(db_record)
        return nil unless db_record
        # rebuild entity
        Entity::StopOfRoute.new(
          sub_route_uid: db_record.sub_route_id,
          stop_uid: db_record.stop_id,
          stop_sequence: db_record.sequence,
          stop_boarding: db_record.boarding
        )
      end
    end
  end
end
