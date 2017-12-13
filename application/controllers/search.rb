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
          puts @allofstops.size
          routing.get do
            # --------start----------
            start = Entity::FindNearestStops.new(@allofstops)
            start.initialize_location(start_lat, start_lng)
            # element [sub_route_id, stop entity, distance]
            start_set = []
            # list of [entity stop,distance] 
            start_near_top_stops_set = start.find_top_nearest_stops
            # start_rank =1
            # start_near_stop is a array, element[0] is stop , element[1] is distance
            start_near_top_stops_set.map do |element|
              start_near_stop = element[0]
              distance = element[1]
              start_sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute].find_stop_id(start_near_stop.id)
              start_sub_routes_of_a_stop.map do |sub|
                start_set << [sub.sub_route.id, start_near_stop, distance]
              end
            end
            start_set.each_with_index do |start1, index1|
              start_set.each_with_index do |start2, index2|
                if index2 != index1
                  if start1[0] == start2[0]
                    if start1[2] < start2[2]
                      start_set.delete(start2)
                    end
                  end
                end
              end
            end
            # --------start---------- 
            # --------dest----------
            dest = Entity::FindNearestStops.new(@allofstops)
            dest.initialize_location(dest_lat, dest_lng)
            dest_set = []
            # list of entity stop
            dest_near_top_stops_set = dest.find_top_nearest_stops
            dest_near_top_stops_set.map do |element|
              dest_near_stop = element[0]
              distance = element[1]
              dest_sub_routes_of_a_stop = Repository::For[Entity::StopOfRoute].find_stop_id(dest_near_stop.id) 
              dest_sub_routes_of_a_stop.map do |sub|
                dest_set << [sub.sub_route.id,dest_near_stop,distance]
              end
            end
            dest_set.each_with_index do |dest1, index1|
              dest_set.each_with_index do |dest2, index2|
                if index2 != index1
                  if dest1[0] == dest2[0]
                    if dest1[2] < dest2[2]
                      dest_set.delete(dest2)
                    end
                  end
                end
              end
            end
            # --------dest----------
            match_set = []
            start_set.each do |s_item|
              dest_set.each do |d_item|
                if d_item[0] == s_item[0]
                  match_set << [s_item[0],s_item[1],d_item[1],s_item[2]+d_item[2]]
                end
              end
            end
            match_sort = {}

            match_set.each do |item| 
              match_sort[item[3]] = [item[0],item[1],item[2]]
            end

            match_sort = match_sort.sort_by { |_key, value| _key }.to_h

            match_sort.map do |_key, value|
              puts _key
            end

            puts "size: #{match_sort.values.size}"
            #---- squence --------
            # start_stops_for_squence = []
            # dest_stops_for_squence = []
            right_squence = []
            match_sort.values.each do |m|
              start_stops_for_squence = Repository::For[Entity::StopOfRoute].find_sub_route_id_and_stop_id(m[0],m[1].id)
              dest_stops_for_squence = Repository::For[Entity::StopOfRoute].find_sub_route_id_and_stop_id(m[0],m[2].id)
              start_stops_for_squence.each do |s_stop|
                dest_stops_for_squence.each do |d_stop|
                  # puts "start #{s_stop.stop_sequence} dest #{d_stop.stop_sequence}"
                  if s_stop.stop_sequence < d_stop.stop_sequence
                    right_squence << m
                    puts "start #{s_stop.stop_sequence} dest #{d_stop.stop_sequence}"
                  end
                  # puts "--------"
                end
              end
            end

            # right_squence.map do |r|
            #   puts r[0]
            # end
            #-----squence --------


            possibleSubRoutes = []
            right_squence.map do |match|
              all_stop_of_sub_route = Repository::For[Entity::StopOfRoute].find_all_stop_of_a_sub_route(match[0])
              possibleSubRoutes << Entity::PossibleSubRoute.new(
                start_stop: match[1],
                dest_stop: match[2],
                stops_of_sub_route: all_stop_of_sub_route
              )
            end
            final = possibleSubRoutes.first 5

            psrs = Entity::PossibleSubRoutes.new(
              sub_route_set: final
            )
            TaiGo::PossibleSubRoutesRepresenter.new(psrs).to_json
          end
        end
      end
    end
  end
end
