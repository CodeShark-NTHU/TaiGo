## TaiGo

[ ![Codeship Status for CodeShark-NTHU/TaiGo](https://app.codeship.com/projects/2b6e5ae0-add7-0135-7c42-1ab1a35cdadc/status?branch=master)](https://app.codeship.com/projects/257309)

### Overview

Use Taiwan's public transportation data to visualize all location of a bus stop and it's routes as well as bike's rent locations across the city.

This app should become very handy for users especially international students and foreigners to get around Hsinchu (priority).

This project is part of our assignment in the Service Oriencted Architecture Class (Fall 20017) in NTHU. 

## Why we make this app?

As international student, especially who cannot read and speak chinese, it's difficult to get know and hop around Hsinchu. If we go to the bus stop, they have no detail information about the route of the bus. Sometimes, what they know only "If you want to go Hsinchu Station, then take bus 1,2, or 182 and get off in the last stop". They don't know anything about the detail of the routes and maybe, within this route, there something hidden gem there, such as very good food, and etc.
## Here's the list of the TaiGo API 
Our API is built on top of MOTC API (ptx.transportdata.tw/MOTC/) and Google Map Direction API (https://developers.google.com/maps/documentation/directions/).
### Page Routes

- GET `api/v0.1/search/stop/coordinates/[start_lat]/[start_lng]/[dest_lat]/[dest_lng]` - returns a json of best routes to go using bus from where you stand (start) to where you go (destination).
- GET `api/v0.1/positions/[city_name]/[route_name]` - returns a json of the current buses of particular route in a city
- GET `api/v0.1/bus/[city_name]/routes` - returns a json of all of routes information in a particular city
- GET `api/v0.1/route/[route_id]` - returns a json of a route information
- GET `api/v0.1/sub_route/[sub_route_id]` - returns a json of a sub-route information
- GET `api/v0.1/bus/[city_name]/stops` - returns a json of all stops in a city
- GET `api/v0.1/stop/[stop_id]` - returns a json of a stop information
- GET `api/v0.1/stop/[stop_id]/sub_route` - returns a json of list of all sub-routes that passing particular stop 
- POST `api/v0.1/bus/[city_name]/updates` - updates the routes, sub-routes, stops, and stop of routes data of a city

## Getting Started

```
1. Clone this project $ git clone git@github.com:CodeShark-NTHU/TaiGo.git 
2. Go to the current folder $ cd TaiGo
3. Install all of the required gem $ bundle install --without production
4. make a secrets.yml file in config file (see ecample in folder config)
    -- To get the `MOTC_ID` and `MOTC_KEY` you need to contact the MOTC via email
5. also configure the workers in `workers/shoryuken.yml`, `workers/shoryuken_dev.yml`, `workers/shoryuken_test.yml`
```
## Automatic Test for the all API

To test this API, simply do the following steps:
```
$ RACK_ENV=test rake db:migrate
$ bundle exec rake spec
```
## Running the API In Local Server

To run the API In local server, do following steps

```
$ RACK_ENV=test rackup -s puma -p 9292
$ RACK_ENV=test bundle exec shoryuken -r ./workers/real_time_bus_worker.rb -C ./workers/shoryuken_test.yml
```

You can change the `RACK_ENV` into either `development`, `test`, or `production`
