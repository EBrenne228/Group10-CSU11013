ArrayList <Flight> flightList;
ArrayList <Screen> screenList;
Screen screen1;
import java.util.List;
import de.bezier.data.sql.*;
SQLite db; // Database connection
PFont widgetFont;
PShape[] states = {};
PShape alabama, alaska, arizona, arkansas, california, colorado, connecticut, delaware, florida, georgia, hawaii, idaho, illinois, indiana, iowa, kansas,
 kentucky, louisiana, maine, maryland, massachusetts, michigan, minnesota, mississippi, missouri, montana, nebraska, nevada, new_hampshire, new_jersey,
 new_mexico, new_york, north_carolina, north_dakota, ohio, oklahoma, oregon, pennsylvania, rhode_island, south_carolina, south_dakota, tennessee, 
 texas, utah, vermont, virginia, washington, west_virginia, wisconsin, wyoming;
America usa;

ArrayList <Airport> airPortList;
Airport JFK = new Airport("JFK");
int countFromJFKweek1, countFromJFKweek2, countFromJFKweek3, countFromJFKweek4;
BarChart bc;
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
      
      
      final PShape USA = loadShape("Usa7.svg");
alabama = USA.getChild("AL");
alaska = USA.getChild("AK");
arizona = USA.getChild("AZ");
arkansas = USA.getChild("AR");
california = USA.getChild("CA");
colorado = USA.getChild("CO");
connecticut = USA.getChild("CT");
delaware = USA.getChild("DE");
florida = USA.getChild("FL");
georgia = USA.getChild("GA");
hawaii = USA.getChild("HI");
idaho = USA.getChild("ID");
illinois = USA.getChild("IL");
indiana = USA.getChild("IN");
iowa = USA.getChild("IA");
kansas= USA.getChild("KS");
kentucky = USA.getChild("KY");
louisiana = USA.getChild("LA");
maine = USA.getChild("ME");
maryland = USA.getChild("MD");
massachusetts = USA.getChild("MA");
michigan = USA.getChild("MI");
 minnesota = USA.getChild("MN");
mississippi = USA.getChild("MS");
missouri = USA.getChild("MO");
montana = USA.getChild("MT");
nebraska = USA.getChild("NE");
nevada = USA.getChild("NV");
new_hampshire = USA.getChild("NH");
new_jersey = USA.getChild("NJ");
new_mexico= USA.getChild("NM");
new_york = USA.getChild("NY");
north_carolina = USA.getChild("NC");
north_dakota = USA.getChild("ND");
ohio = USA.getChild("OH");
oklahoma = USA.getChild("OK");
oregon = USA.getChild("OR");
pennsylvania = USA.getChild("PA");
rhode_island = USA.getChild("RI");
south_carolina = USA.getChild("SC");
south_dakota  = USA.getChild("SD");
tennessee = USA.getChild("TN");
texas = USA.getChild("TX");
utah = USA.getChild("UT");
vermont = USA.getChild("VT");
virginia = USA.getChild("VA");
washington = USA.getChild("WA");
west_virginia = USA.getChild("WV");
wisconsin = USA.getChild("WI");
wyoming = USA.getChild("WY");

    PShape states[] = {alabama, alaska, arizona, arkansas, california, colorado, connecticut, delaware, florida, georgia, hawaii, idaho, illinois, indiana, iowa, kansas,
    kentucky, louisiana, maine, maryland, massachusetts, michigan, minnesota, mississippi, missouri, montana, nebraska, nevada, new_hampshire, new_jersey,
new_mexico, new_york, north_carolina, north_dakota, ohio, oklahoma, oregon, pennsylvania, rhode_island, south_carolina, south_dakota, tennessee,
texas, utah, vermont, virginia, washington, west_virginia, wisconsin, wyoming};
 
 usa = new America(USA, states);
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
