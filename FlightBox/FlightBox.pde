import java.util.List;
import de.bezier.data.sql.*;
SQLite db; // Database connection

/*
 * Convert a database flight record into a Flight object.
 */
Flight recordToFlight(SQLite db) {
  return new Flight(
    db.getString("fl_date"), db.getString("mkt_carrier"), db.getInt("mkt_carrier_fl_num"),
    db.getString("origin"), db.getString("origin_city_name"), db.getString("origin_state_abr"),
    db.getString("dest"), db.getString("dest_city_name"), db.getString("dest_state_abr"),
    db.getBoolean("cancelled"), db.getBoolean("diverted"),
    db.getInt("distance")
  );
}

void setup() {
  size( 450, 450 );

  Flight flight;

  db = new SQLite( this, "data/flights.sqlite" );

  if (!db.connect()) {
    println("Problem opening database");
  } else {
    // Samples of some of the different types of queries we can run against the database

    // Number of flights in the database
    println("Number of flight in the database");
    db.query("SELECT COUNT(*) AS total FROM flights");
    int count = db.getInt("total");
    println(">>> count = " + count);
    println();

    // Number of flights originating in SFO that are destined for JKF
    println("Number of flights from SFO to JFK");
    db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = 'SFO' AND dest = 'JFK' LIMIT 10");
    count = db.getInt("total");
    println(">>> count = " + count);
    println();
  }
}
