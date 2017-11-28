# frozen_string_literal: true

module TaiGo
  module Repository
    # Repository for StopOfRoutes table
    class StopOfRoutes
      def self.find_all_stop_of_a_sub_route(sub_route_id)
        db_records = Database::StopOfRouteOrm.where(sub_route_id: sub_route_id)
        db_records.map { |record| rebuild_entity(record) }
      end

      def self.find_stop_id(stop_id)
        db_records = Database::StopOfRouteOrm.distinct.where(stop_id: stop_id)
        db_records.map { |db_record| rebuild_entity(db_record) }
      end

      def self.find_stop_of_route(sub_route_id, stop_id, sequence)
        db_record = Database::StopOfRouteOrm.first(sub_route_id: sub_route_id,
                                                   stop_id: stop_id,
                                                   sequence: sequence)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find_stop_of_route(entity.sub_route_id,
                           entity.stop_uid,
                           entity.stop_sequence) || create_from(entity)
      end

      def self.create_from(entity)
        Database::StopOfRouteOrm.unrestrict_primary_key
        db_stop_of_route = Database::StopOfRouteOrm.create(
          sub_route_id: entity.sub_route_id,
          stop_id: entity.stop_id,
          sequence: entity.stop_sequence,
          boarding: entity.stop_boarding
        )
        rebuild_entity(db_stop_of_route)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        # stop = nil
        stop = Stops.rebuild_entity(db_record.stop)

        # subroute = nil
        subroute = SubRoutes.rebuild_entity(db_record.sub_route)

        # rebuild entity
        Entity::StopOfRoute.new(
          sub_route_id: db_record.sub_route_id,
          stop_id: db_record.stop_id,
          stop_sequence: db_record.sequence,
          stop_boarding: db_record.boarding,
          sub_route: subroute,
          stop: stop
        )
      end
    end
  end
end
