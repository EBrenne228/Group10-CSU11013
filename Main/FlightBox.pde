/*
 *
 * FlightBox by James
 * Initial SQL setup 
 *
 */
Flight recordToFlight(SQLite db)  //  Convert a database flight record into a Flight object.
{
  return new Flight( db.getString("fl_date"),db.getString("mkt_carrier"),db.getInt("mkt_carrier_fl_num"),
  db.getString("origin"),db.getString("origin_city_name"),db.getString("origin_state_abr"),
  db.getString("dest"),db.getString("dest_city_name"),db.getString("dest_state_abr"),
  db.getBoolean("cancelled"),db.getBoolean("diverted"),
  db.getInt("distance") );
}



 /*
* Method for heatmap to find number of flights leaving a state
*
* originState should be in format: "TX", "NY" for example.
*/       
public int flightsFromEachState (String originState) 
{
  db.query("SELECT COUNT(*) AS total FROM flights WHERE origin_state_abr = '%s'", originState);
  return db.getInt("total");
}

 /*
* Method for heatmap to find number of flights to a state
*
* destinationState should be in format: "TX", "NY" for example.
*/       
public int flightsToEachState (String destinationState) 
{
  db.query("SELECT COUNT(*) AS total FROM flights WHERE dest_state_abr = '%s'", destinationState);
  return db.getInt("total");
}
