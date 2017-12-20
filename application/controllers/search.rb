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
          directions = TaiGo::GoogleMapDirection.call(
            start_lat: start_lat,
            start_lng: start_lng,
            dest_lat: dest_lat,
            dest_lng: dest_lng)
          # puts directions
          # result = directions.value.values[0]
          http_response = HttpResponseRepresenter.new(directions.value)
          response.status = http_response.http_code
          @sor_set = []
          if directions.success?
            result = directions.value.message
            result.each do |x|
              bhima = x.bus_steps
              bhima.each do |b|
                # name_zh = b.bus_sub_route_name
                name_zh = b.bus_sub_route_name
                name_zh.insert 1, '線' if name_zh[0] == '藍' && name_zh[2] == '區'
                name_zh.concat('號') if name_zh[0..1] == '世博'
                route = Repository::For[Entity::BusRoute].find_name_ch(name_zh)
                # puts name_zh
                # puts b.bus_num_stops
                if route.nil?
                  puts "not in Hsinchu City"
                else
                  route_id = route.id
                  # puts route_id
                  subroutes = Repository::For[Entity::BusSubRoute].find_sub_route_by_id(route_id)
                  subroutes.each do |sub|
                    sub_route_id = sub.id
                    puts sub.name.chinese
                    stops_of_sub_route = Repository::For[Entity::StopOfRoute]
                                     .find_all_stop_of_a_sub_route(sub_route_id)
                    # puts "bus_departure_stop_name: #{b.bus_departure_stop_name}"
                    # puts "bus_arrival_stop_name: #{b.bus_arrival_stop_name}"
                    departure_arr = []
                    arrival_arr = []
                    i_want_you = false
                    stops_of_sub_route.each do |sor|
                      # puts "#{sor.stop_sequence} #{sor.stop.name.chinese}"
                      if sor.stop.name.chinese == b.bus_departure_stop_name
                        departure_arr << sor.stop_sequence
                      end
                      if sor.stop.name.chinese == b.bus_arrival_stop_name
                        arrival_arr << sor.stop_sequence
                      end
                    end
                    departure_arr.each do |departure|
                      arrival_arr.each do |arrival|
                        if (arrival - departure) == b.bus_num_stops
                          i_want_you = true
                          break
                        end
                      end
                    end
                    i_want_you = true
                    if i_want_you
                      sub_route_name_ch = "#{stops_of_sub_route[0].sub_route.name.chinese} #{stops_of_sub_route[0].sub_route.headsign}"
                      @sor_set << Entity::StopsOfSubRoute.new(sub_route_name_ch: sub_route_name_ch,stops_of_sub_route: stops_of_sub_route)
                      # puts "we need this sub route."
                      i_want_you = false
                    end
                  end
                  #puts "b.:"+b.stops_of_sub_routes[0]
                  # puts b.stops_of_sub_routes.size
                  puts @sor_set.class
                  @sor_set.each do |sor|
                    b.stops_of_sub_routes << sor
                  end
                  # puts b.stops_of_sub_routes
                  @sor_set = []
                end
                # puts sub_route.class
                # puts SubRouteRepresenter.new(sub_route).to_json if sub_route != nil
              end
            end
            # puts result
            PossibleWaysRepresenter.new(PossibleWays.new(result)).to_json
          else
            http_response.to_json
          end
        end
      end
    end
  end
end

=begin
          possible_sub_routes = FindPossibleSubRoutesV2.new.call(
            s_lat: start_lat,
            s_lng: start_lng,
            d_lat: dest_lat,
            d_lng: dest_lng
          )
          final = possible_sub_routes.value.values
          puts final[0]
          psrs = Entity::PossibleSubRoutes.new(
            sub_route_set: final[0]
          )
          TaiGo::PossibleSubRoutesRepresenter.new(psrs).to_json
=end