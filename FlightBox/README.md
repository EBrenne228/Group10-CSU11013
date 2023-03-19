# FlightBox
Demo to load data into a [SQLite](https://sqlite.org/) database and run some queries from [Processing](https://processing.org).

# Getting set up
## Install SQLite
The project uses a SQLite database. To create the database you're first going to need to install [SQLite](https://sqlite.org/).

On Mac, `brew install sqlite`. For other platforms have a look at the [download instructions](https://www.sqlite.org/download.html).

## Import Database
The `data` directory contains the data and scripts necessary to create the SQLite database
- `flights_full.csv` - flight data in CSV format
- `world_area_codes.csv` - WAC data
- `load-data.txt` - SQLite script to create the database and load and clean the data

To create the database and load the data:

```
$ cd data
$ sqlite3 -init load-data.txt flights.sqlite ""
```

## Install BezierSQLib
To use SQLite from Processing you need to install [BezierSQLib](http://bezier.de/processing/libs/sql/) ([docs](http://bezier.de/processing/libs/sql/)) is a library to allow [Processing](https://processing.org/). To install it:
- Open Tools | Manage Tools...
- Select "Libraries" tab
- Select "BezierSQLib"
- Click "Install"