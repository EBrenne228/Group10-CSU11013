import controlP5.*;
import java.util.List;
import de.bezier.data.sql.*;


ArrayList <Flight> flightList;
ArrayList <Screen> screenList;
Screen screen1;
SQLite db; // Database connection
PFont widgetFont;

ArrayList <Airport> originatingAirportList, destinationAirportList;
BarChart bc;
PFont ourFont;


// bar chart variables
float [] flightsFromOriginweekly;
float [] flightsFromOriginDaily;
float [] flightsToDestWeekly;
float [] flightsToDestDaily;
int countFromOriginweek1,countFromOriginweek2, countFromOriginweek3, countFromOriginweek4;
int countFromOriginDay1,countFromOriginDay2, countFromOriginDay3, countFromOriginDay4, countFromOriginDay5, countFromOriginDay6, countFromOriginDay7;
boolean drawBarChart;
boolean hoverBarChart;
int hoverCount;
boolean airline, flightNum, depAirport, depCity, depState, depWac, arrCRS, arrTime,
destAirport, destCity, destState, destWac, depCRS, depTime, flightCancel, flightDivert, distance,
byFilter, perFilter;

ControlP5 CP5;
DropdownList dropDownList, departureDDL;




void setup(){
  size( 1280, 720);
    
    CP5 = new ControlP5(this);
    dropDownList = CP5.addDropdownList("Select Origin")
                   .setPosition(50,20);
    departureDDL = CP5.addDropdownList("Select Destination")
                   .setPosition(SCREEN_X - 150 ,20);
     
                   
     
                   
                   
    
     
    originatingAirportList = new ArrayList <Airport>();
     destinationAirportList = new ArrayList <Airport>();    
    db = new SQLite(this,"data/flights.sqlite"); // currently this database is using 100k flights for faster queries, once we optimise will shift to the largest dataset
    ourFont = loadFont("AmericanTypewriter-Light-150.vlw");
    textFont(ourFont);
    

  hoverBarChart=false;
  hoverCount=0;
  drawBarChart=true;
  perFilter=true;
  depAirport=true;
  depCity=true;
  depState=true; 
  depWac = true;
  


    if(!db.connect())
    {
        println("Problem opening database");
    }
    else
    {
      
        db.query("SELECT origin FROM flights GROUP BY origin");
        while (db.next())
        {
          originatingAirportList.add(new Airport(db.getString("origin")));
          dropDownList.addItem(db.getString("origin"), 1);
        }
        db.query("SELECT dest FROM flights GROUP BY dest");
        while (db.next())
        {
          destinationAirportList.add(new Airport(db.getString("dest")));
          departureDDL.addItem(db.getString("dest"), 1);
        }
        
     }
      flightsFromOriginweekly = new float[4];
      flightsFromOriginDaily = new float[6];
      bc = new BarChart( flightsFromOriginDaily, " ");
      bc.depLoc = " ";
     
}
  Flight recordToFlight(SQLite db) //Converts a database flight record into a Flight object.
{
      return new Flight( db.getString("fl_date"),db.getString("mkt_carrier"),db.getInt("mkt_carrier_fl_num"),
      db.getString("origin"),db.getString("origin_city_name"),db.getString("origin_state_abr"),
      db.getString("dest"),db.getString("dest_city_name"),db.getString("dest_state_abr"),
      db.getBoolean("cancelled"),db.getBoolean("diverted"),
      db.getInt("distance") );
}

void initialiseData ()
{
}


void draw()
{
  background(255);
  
  text("Number of Flights Weekly from JFK", SCREEN_X + 100, SCREEN_Y/2);
  bc.draw();
  bc.barHover(mouseX, mouseY);
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
          String origin = originatingAirportList.get((int)theEvent.getController().getValue()).name;
          bc.depLoc = origin;
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date ='2022-01-01'", origin);
          countFromOriginDay1 = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-02' ", origin);
          countFromOriginDay2 = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-03'", origin);
          countFromOriginDay3 = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-04'  ", origin);
          countFromOriginDay4 = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-05'  ", origin);
          countFromOriginDay5 = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-06'  ", origin);
          countFromOriginDay6 = db.getInt("total");
       
        
          flightsFromOriginDaily[0] = countFromOriginDay1;
          flightsFromOriginDaily[1] = countFromOriginDay2;
          flightsFromOriginDaily[2] = countFromOriginDay3;
          flightsFromOriginDaily[3] = countFromOriginDay4;
          flightsFromOriginDaily[4] = countFromOriginDay5;
          flightsFromOriginDaily[5] = countFromOriginDay6;
          
          println(originatingAirportList.size());
          
          bc = new BarChart(flightsFromOriginDaily, "Day");
          bc.depLoc = origin;
          println("event from controller : " + theEvent.getController().getValue() + " from " + theEvent.getController());
  }
}
