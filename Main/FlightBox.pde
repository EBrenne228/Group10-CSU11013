/*
import java.util.List;
import de.bezier.data.sql.*;
SQLite db; // Database connection
ArrayList <Airport> airPortList;
int countFromJFKweek1, countFromJFKweek2, countFromJFKweek3, countFromJFKweek4;
BarChart bc;

Airport JFK = new Airport("JFK");
PFont ourFont;


void setup(){
  size( 1280, 720);
    airPortList = new ArrayList <Airport>();
    db=new SQLite(this,"data/flights.sqlite");
    ourFont = loadFont("AmericanTypewriter-Light-150.vlw");
    textFont(ourFont);

    if(!db.connect())
    {
        println("Problem opening database");
    }
    else
    {
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = 'JFK' AND fl_date BETWEEN '2022-01-01' AND '2022-01-07' ");
        countFromJFKweek1 = db.getInt("total");
        
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = 'JFK' AND fl_date BETWEEN '2022-01-08' AND '2022-01-14' ");
        countFromJFKweek2 = db.getInt("total");
        
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = 'JFK' AND fl_date BETWEEN '2022-01-015' AND '2022-01-21' ");
        countFromJFKweek3 = db.getInt("total");
        
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = 'JFK' AND fl_date BETWEEN '2022-01-22' AND '2022-01-28' ");
        countFromJFKweek4 = db.getInt("total");
     }
     
      float [] flightsFromJFKweekly = {countFromJFKweek1, countFromJFKweek2, countFromJFKweek3, countFromJFKweek4};
      bc = new BarChart(flightsFromJFKweekly);
}
  
  Flight recordToFlight(SQLite db) //Converts a database flight record into a Flight object.
{
      return new Flight( db.getString("fl_date"),db.getString("mkt_carrier"),db.getInt("mkt_carrier_fl_num"),
      db.getString("origin"),db.getString("origin_city_name"),db.getString("origin_state_abr"),
      db.getString("dest"),db.getString("dest_city_name"),db.getString("dest_state_abr"),
      db.getBoolean("cancelled"),db.getBoolean("diverted"),
      db.getInt("distance") );
}

void draw()
{
  background(255);
  
  text("Number of Flights Weekly from JFK", SCREEN_X + 100, SCREEN_Y/2);
  bc.draw();
}
*/
       
        

       
