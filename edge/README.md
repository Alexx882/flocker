# Flutter edge 

## POST location
`curl https://flocker.anja.codes  -H "Content-Type: application/json" -d '{"latitude": 0, "longitude": 0, "timestamp": 0, "username": "string"}'`
filters all locations and only forwards those in a distance of 0.5km around the center of aau to the cloud.

## GET clusters
`curl https://flocker.anja.codes/clusters`
returns clustering results from cloud. caches for 3600 s before fetching most recent data from cloud.

## GET popular-locations
`curl https://flocker.anja.codes/locations`
returns for each day the top three most popular locations from the cloud.

## Debug stuff
`curl https://flocker.anja.codes/data`
generates dummy data and forwards it to the cloud.

https://flocker.anja.codes
shows the clusters of each hour in list view