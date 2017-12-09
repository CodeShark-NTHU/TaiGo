# frozen_string_literal: true

module TaiGo
  # Web API
  class Api < Roda
    plugin :all_verbs

    route('search') do |routing|
      # #{API_ROOT}/search index request
      routing.is do
        routing.get do
          message = 'API to get the best routes between start and dest'
          HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
        end
      end

      # #{API_ROOT}/search/stop/coordinates/:start_lat/:start_lng/:dest_lat/:dest_lng
      routing.on 'stop' do
        routing.on 'coordinates', String, String, String, String do |start_lat, start_lng, dest_lat, dest_lng|
          # GET '#{API_ROOT}/search/stop/coordinates/:start_lat/:start_lng/:dest_lat/:dest_lng'
          # Hsinchu station 24.801672, 120.971561
          # library 24.795495, 120.994723
          find_result = FindDatabaseAllOfStops.call
          routing.halt(404, 'There are no stops in db') if find_result.failure?
          @allofstops = find_result.value.message
          routing.get do

            # --------start----------
            start = Entity::FindNearestStops.new(@allofstops)
            start.initialize_location(start_lat, start_lng)
            start_sub_route_id_set = []
            # list of entity stop
            start_near_top_stops = start.find_top_nearest_stops

            start_rank =1
            start_near_top_stops.map do |start_near_stop|
              start_sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute].find_stop_id(start_near_stop.id)
              start_sub_routes_of_a_stop.map do |sub|
                # puts "id: #{sub.sub_route.id} rank :#{start_rank}"
                start_sub_route_id_set << [sub.sub_route.id,start_near_stop,start_rank]
              end
              start_rank += 1
              # puts "-----"
            end
            start_sub_route_id_set.each_with_index do |s1, i1|
              start_sub_route_id_set.each_with_index do |s2, i2|
                if i2 != i1
                  if s1[0] == s2[0]
                    if s1[2] < s2[2]
                      start_sub_route_id_set.delete(s2)
                    end
                  end
                end
              end
            end
=begin
            start_sub_route_id_set.map do |subroute|
              puts "#{subroute[0]} #{subroute[1].id} #{subroute[2]}"
            end
=end
            # --------start---------- 
            puts "----"
            # --------dest----------
            dest = Entity::FindNearestStops.new(@allofstops)
            dest.initialize_location(dest_lat, dest_lng)
            dest_sub_route_id_set = []
            # list of entity stop
            dest_near_top_stops = dest.find_top_nearest_stops
            dest_rank =1
            dest_near_top_stops.map do |dest_near_stop|
              dest_sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute].find_stop_id(dest_near_stop.id) 
              dest_sub_routes_of_a_stop.map do |sub|
                dest_sub_route_id_set << [sub.sub_route.id,dest_near_stop,dest_rank]
              end
              dest_rank += 1
            end

            dest_sub_route_id_set.each_with_index do |s1, i1|
              dest_sub_route_id_set.each_with_index do |s2, i2|
                if i2 != i1
                  if s1[0] == s2[0]
                    if s1[2] < s2[2]
                      dest_sub_route_id_set.delete(s2)
                    end
                  end
                end
              end
            end
=begin
            dest_sub_route_id_set.map do |subroute|
              puts "#{subroute[0]} #{subroute[1].id} #{subroute[2]}"
            end
=end
            # --------dest----------
            final_result = []
            start_sub_route_id_set.each do |s_item|
              dest_sub_route_id_set.each do |d_item|
                if d_item[0] == s_item[0]
                  final_result << [s_item[0],s_item[1],d_item[1]]
                end
              end
            end
            # --------start----------
            possibleSubRoutes = []
            final_result.map do |result|
              all_stop_of_sub_route = Repository::For[Entity::StopOfRoute].find_all_stop_of_a_sub_route(result[0])
              possibleSubRoutes << Entity::PossibleSubRoute.new(
                start_stop: result[1],
                dest_stop: result[2],
                stops_of_sub_route: all_stop_of_sub_route
              )
            end
            final = possibleSubRoutes.first 5

            psrs = Entity::PossibleSubRoutes.new(
              sub_route_set: final
            )
            TaiGo::PossibleSubRoutesRepresenter.new(psrs).to_json

            # sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute].find_stop_id(nearest_stop.id) 
            # sub_routes_of_a_stop.map do |sub|
            #   puts sub.sub_route.name.english
            #end
            # StopOfRoutesRepresenter.new(Stopofroutes.new(sub_routes_of_a_stop)).to_json
            # pss = Entity::FindPossibleSubSubroutes.new(nearest_stop, start_lat, start_lng)
            # TaiGo::PossibleSubRoutesRepresenter.new(pss.build_entity).to_json
          end
        end
      end
    end
  end
end
