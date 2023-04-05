import java.util.List;
import de.bezier.data.sql.*;
SQLite db; // Database connection

        /*
         * Convert a database flight record into a Flight object.
         */
        Flight recordToFlight(SQLite db){
        return new Flight(
        db.getString("fl_date"),db.getString("mkt_carrier"),db.getInt("mkt_carrier_fl_num"),
        db.getString("origin"),db.getString("origin_city_name"),db.getString("origin_state_abr"),
        db.getString("dest"),db.getString("dest_city_name"),db.getString("dest_state_abr"),
        db.getBoolean("cancelled"),db.getBoolean("diverted"),
        db.getInt("distance")
        );
        }

        void setup(){
  size( 450, 450 );

        Flight flight;

        db=new SQLite(this,"data/flights.sqlite");

        if(!db.connect()){
        println("Problem opening database");
        }else{
        // Samples of some of the different types of queries we can run against the database

        // Number of flights in the database
        
        println("Number of flight in the database");
        db.query("SELECT COUNT(*) AS total FROM flights");
        int count=db.getInt("total");
        println(">>> count = "+count);
        println();

        // Number of flights originating in SFO that are destined for JKF
        println("Number of flights from SFO to JFK");
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = 'SFO' AND dest = 'JFK'");
        count=db.getInt("total");
        println(">>> count = "+count);
        println();

        // Number of flights originating in SFO that are destined for JKF on 7-Jan-2022
        println("Number of flights from SFO to JFK on 7-Jan-2022");
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = 'SFO' AND dest = 'JFK' AND fl_date = '2022-01-07'");
        count=db.getInt("total");
        println(">>> count = "+count);
        println();

        // First 10 flights
        println("First 10 flights in the database");
        db.query("SELECT * FROM flights LIMIT 10");

        while(db.next()){
        flight=recordToFlight(db);
        println(">>> "+flight);
        }
        println();

        // First 10 flights from SFO to JFK
        println("First 10 flights from SFO to JFK");
        db.query("SELECT * FROM flights WHERE origin = 'SFO' AND dest = 'JFK' LIMIT 10");

        while(db.next()){
        flight=recordToFlight(db);
        println(">>> "+flight);
        }
        println();

        // Top airlines to cancel flights
        println("Top airlines to cancel flights");
        db.query("SELECT mkt_carrier, COUNT(*) AS count "+
        "FROM flights "+
        "WHERE cancelled = 1 "+
        "GROUP BY mkt_carrier "+
        "ORDER BY count DESC");

        while(db.next()){
        println(String.format(">>> %s %5d",db.getString("mkt_carrier"),db.getInt("count")));
        }

        // Originating airports
        println("Originating airports (be patient - this query is slow)");
        db.query("SELECT origin FROM flights GROUP BY origin");
        while(db.next()){
        println(">>> "+db.getString("origin"));
        }
        println();
        
        // 
        }
        }
