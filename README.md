## TaiGo

[ ![Codeship Status for CodeShark-NTHU/TaiGo](https://app.codeship.com/projects/2b6e5ae0-add7-0135-7c42-1ab1a35cdadc/status?branch=master)](https://app.codeship.com/projects/257309)

### Overview

Use Taiwan's public transportation data to visualize all location of a bus stop and it's routes as well as bike's rent locations across the city.

This app should become very handy for users especially international students and foreigners to get around Hsinchu (priority).

## Why we make this app?

As international student, especially who cannot read and speak chinese, it's difficult to get know and hop around Hsinchu. If we go to the bus stop, they have no detail information about the route of the bus. Sometimes, what they know only "If you want to go Hsinchu Station, then take bus 1,2, or 182 and get off in the last stop". They don't know anything about the detail of the routes and maybe, within this route, there something hidden gem there, such as very good food, and etc.

## Existing solution

There are some existing solutions that already made, such as, Hsinchu Bus Timetable. But, however, this app only available limited to android users. While some functions are good, we can make it better accessbility and focused on visualization.

#1 First priority 
The first of this project is to visualize Hsinchu public transportation especially Bus and Bike Station.

For this purpose, we will utilitize the open API provided by Ministry of Transportation and Communication (MOTC) of Taiwan. 
The API Documentation can be found in this link: http://ptx.transportdata.tw/MOTC/#. 

As for the visualization, we will use either Google API and Mapbox API. 
the API Documentation can also be found in 
Google API : https://developers.google.com/maps/documentation/api-picker 
Mapbox API : https://www.mapbox.com/api-documentation/?language=cURL#introduction


#2 Second priority 
The second priority of our is to provide users with more information, such as, shop, restaurant, and attraction nearby the bus stops / bike stations / MRT stations.

We still discuss and explore the APIs option that we can use to provide such information.