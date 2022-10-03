# NeoGraph
Generate a SwiftUI Chart showing the current near Earth objects data from NeoWs (Near Earth Object Web Service).

## Neo - Feed

Retrieve a list of Asteroids based on their closest approach date to Earth. `GET https://api.nasa.gov/neo/rest/v1/feed?start_date=START_DATE&end_date=END_DATE&api_key=API_KEY` 

### Query Parameters

| Paramter   | Type       | Default                 | Description                           |
| ---------- | ---------- | ----------------------- | ------------------------------------- |
| start_date | YYYY-MM-DD | none                    | Starting date for the asteroid search |
| end_date   | YYYY-MM-DD | 7 days after start_date | Ending date for the asteroid search   |
| api_key    | string     | DEMO_KEY                | api.nasa.gov key for expanded usage   |
|            |            |                         |                                       |

### Example query

[`https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY`](https://api.nasa.gov/neo/rest/v1/feed?start_date=2015-09-07&end_date=2015-09-08&api_key=DEMO_KEY) 

## Neo - Lookup

Lookup a specific Asteroid based on its [NASA JPL small body (SPK-ID) ID](http://ssd.jpl.nasa.gov/sbdb_query.cgi) `GET https://api.nasa.gov/neo/rest/v1/neo/` 

### Path Parameters

| Paramter    | Type   | Default  | Description                                           |
| ----------- | ------ | -------- | ----------------------------------------------------- |
| asteroid_id | int    | none     | Asteroid SPK-ID correlates to the NASA JPL small body |
| api_key     | string | DEMO_KEY | api.nasa.gov key for expanded usage                                                      |


### Example query

[`https://api.nasa.gov/neo/rest/v1/neo/3542519?api_key=DEMO_KEY`](https://api.nasa.gov/neo/rest/v1/neo/3542519?api_key=DEMO_KEY) 

## Neo - Browse

Browse the overall Asteroid data-set `GET https://api.nasa.gov/neo/rest/v1/neo/browse/` 

### Example query

[`https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=DEMO_KEY`](https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=DEMO_KEY)
