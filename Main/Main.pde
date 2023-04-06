import controlP5.*;
import java.util.List;
import de.bezier.data.sql.*;
import java.util.Arrays;



ArrayList <Flight> flightList;
ArrayList <Screen> screenList;
Screen screen1;
SQLite db; // Database connection

HashMap<Integer, Flight> flightMap;
HashMap<String, Flight> airportMap;
ArrayList <Airport> originatingAirportList, destinationAirportList;
ArrayList <State> stateList;
BarChart bc;
PFont ourFont, widgetFont;


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

//widgets and buttons
Widget chartScreenButton,chartScreenButton_2,mapScreenButton, homeScreenButton,homeScreenButton_2, heatMapButton, heatMapButton_2;
Screen homeScreen, chartScreen, heatMapScreen, pathScreen, currentScreen;

ControlP5 CP5;
DropdownList dropDownList, departureDDL;




//loading screen stuff

boolean pause = false;
boolean loadingScreen = true;
boolean homePageUi = false;
import gifAnimation.*;
public Gif nonLoopingGif;

//setting up heatmap/america
public PShape alabama, alaska, arizona, arkansas, california, colorado, connecticut, delaware, florida, georgia, hawaii, idaho, illinois, indiana, iowa, kansas,
  kentucky, louisiana, maine, maryland, massachusetts, michigan, minnesota, mississippi, missouri, montana, nebraska, nevada, new_hampshire, new_jersey,
  new_mexico, new_york, north_carolina, north_dakota, ohio, oklahoma, oregon, pennsylvania, rhode_island, south_carolina, south_dakota, tennessee,
  texas, utah, vermont, virginia, washington, west_virginia, wisconsin, wyoming;
 public America usa;
 int[] zeros = new int[50]; //dummydata for getting heatmap up
 int [] flightsFromStates = new int [50];
 int [] flightsToStates = new int [50];






void setup(){
  size(1280, 720);
  frameRate(100);
  
  //set up for loading screen
  nonLoopingGif = new Gif(this, "gifgit_1.gif");
  nonLoopingGif.play();
  nonLoopingGif.ignoreRepeat();
  
  
  CP5 = new ControlP5(this);
  stateList = new ArrayList<State>();
  
  
  
  
  db = new SQLite(this,"data/flights.sqlite"); // currently this database is using 100k flights for faster queries, once we optimise will shift to the largest dataset
  db.connect();
  thread("initialQuery"); // runs inital queries/loading of data on a separate thread from the "Animation" thread.

  ourFont = loadFont("AmericanTypewriter-Light-150.vlw");
  widgetFont = loadFont("AmericanTypewriter-Light-20.vlw");
    
  flightMap = new HashMap<Integer, Flight>();
  airportMap = new HashMap<String, Flight>();
    
   //defining buttons
   
   
       //home screen based buttons
   
   chartScreenButton = new Widget(575, 600, 125, 50, "Charts", color(#18AD77), widgetFont, EVENT_TO_CHARTS);
   heatMapButton = new Widget(385, 600, 135, 50, "HeatMap", color(#18AD77), widgetFont, EVENT_TO_HEATMAPS);
   
   
   //heatMap based buttons
   
   homeScreenButton = new Widget(365, 600, 155, 50, "Home Screen", color(#18AD77), widgetFont, EVENT_TO_HOME);
   chartScreenButton_2 = new Widget(575, 600, 125, 50, "Charts", color(#18AD77), widgetFont, EVENT_TO_CHARTS);

   
    //chart screen based buttons
   homeScreenButton_2 = new Widget(335, 600, 185, 50, "Home Screen", color(#18AD77), widgetFont, EVENT_TO_HOME);
   heatMapButton_2 = new Widget(575, 600, 135, 50, "HeatMap", color(#18AD77), widgetFont, EVENT_TO_HEATMAPS);
      
   
   
  
 //defining screens
   
   
   homeScreen = new Screen(color(0), this, true, false, false);
   chartScreen = new Screen (color(50), this, false, false, true);
   heatMapScreen = new Screen (color(255), this, false, true,false);
   //pathScreen = new Screen (color(0), this);
   
   
   
   currentScreen = homeScreen;
   homeScreen.addWidget(heatMapButton);
   homeScreen.addWidget(chartScreenButton);
   chartScreen.addWidget(homeScreenButton_2);
   chartScreen.addWidget(heatMapButton_2);
   heatMapScreen.addWidget(homeScreenButton);
   heatMapScreen.addWidget(chartScreenButton_2);
     
   
   dropDownList =CP5.addDropdownList("Select Origin")
                   .setPosition(50,20);
   //departureDDL = CP5.addDropdownList("Select Destination")
   //                .setPosition(SCREEN_X - 150 ,20);
  
     
  currentScreen = homeScreen;
                   
 
     
  originatingAirportList = new ArrayList <Airport>();
  destinationAirportList = new ArrayList <Airport>();    

  //bar chart setup
  hoverBarChart = false;
  hoverCount = 0;
  drawBarChart = true;
  byFilter = true;
  chartScreen.bc.byStr = "Airlines";
  flightCancel = true;


  if(!db.connect())
  {
      println("Problem opening database");
  }
    
  //outdated barchart setup
  
  
//    else
//    {
    
//        db.query("SELECT origin FROM flights GROUP BY origin");
//        while (db.next())
//        {
//          originatingAirportList.add(new Airport(db.getString("origin")));
//          dropDownList.addItem(db.getString("origin"), 1);
//        }
//        db.query("SELECT dest FROM flights GROUP BY dest");
//        while (db.next())
//        {
//          destinationAirportList.add(new Airport(db.getString("dest")));
//          departureDDL.addItem(db.getString("dest"), 1);
//        }
      
//     }
      flightsFromOriginweekly = new float[4];
      flightsFromOriginDaily = new float[6];
//      bc = new BarChart( flightsFromOriginDaily, " ");
//      bc.depLoc = " ";
   
//}
//setting up heatmap please forgive the wall of code



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
    println(states.length);
   usa = new America(USA, states);
   usa.blankAmerica();
   usa.setHeatMapRanges(0,10,40,50,80);
   Arrays.fill(zeros,0);


}
  Flight recordToFlight(SQLite db) //Converts a database flight record into a Flight object.
{
      return new Flight( db.getString("fl_date"),db.getString("mkt_carrier"),db.getInt("mkt_carrier_fl_num"),
      db.getString("origin"),db.getString("origin_city_name"),db.getString("origin_state_abr"),
      db.getString("dest"),db.getString("dest_city_name"),db.getString("dest_state_abr"),
      db.getBoolean("cancelled"),db.getBoolean("diverted"),
      db.getInt("distance") );
}

void initialQuery()
{
     db.query("SELECT  origin FROM flights GROUP BY origin");
     while (db.next())
      {
        originatingAirportList.add(new Airport(db.getString("origin")));
        dropDownList.addItem(db.getString("origin"), 1);
       }
      
      db.query("SELECT mkt_carrier FROM flights GROUP BY origin");
     // db.query("SELECT dest FROM flights GROUP BY dest");
     // while (db.next())
     // {
     //   destinationAirportList.add(new Airport(db.getString("dest")));
     //   //departureDDL.addItem(db.getString("dest"), 1);
     // }
    
    //  int hashKey = 0;
    //  Flight temp;
    //  db.query("SELECT * FROM flights"); 
    //  while (db.next())
    //  {
    //    temp = recordToFlight(db);
    //    flightMap.put(hashKey, temp);
    //    hashKey++;
    //  }
      
      //heatMap queries
      State tempState;
      int index = 0;
      db.query("Select origin_state_abr FROM flights GROUP BY origin_state_abr");
      while (db.next())
      {
        tempState = new State(db.getString("origin_state_abr"));
        stateList.add(tempState);
        index++;
      }
      stateList.remove(38);
      stateList.remove(43);
      stateList.remove(47);
      
      for(int index1 = 0; index < stateList.size(); index1++)
      {
        flightsFromStates[index] = flightsFromEachState(stateList.get(index1).name);
        flightsToStates[index] = flightsToEachState(stateList.get(index1).name);
      }
      println("done");
}


void draw()
{
  
  
 // background(255);
  //image(nonLoopingGif, width/2 - nonLoopingGif.width/2, height / 2 - nonLoopingGif.height / 2);
  //bc.draw();
  //bc.barHover(mouseX, mouseY);
  
 
  currentScreen.draw();
 
  


}

void controlEvent(ControlEvent theEvent) 
{
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
          
          chartScreen.bc = new BarChart(flightsFromOriginDaily, "Day");
          chartScreen.bc.depLoc = origin;
          println("event from controller : " + theEvent.getController().getValue() + " from " + theEvent.getController());
  }
}

void mousePressed()
{
  int event = currentScreen.getEvent();
  switch (event)
  {
     case EVENT_TO_CHARTS:
       currentScreen = chartScreen;
       
       break;
     case EVENT_TO_HOME:
     
       currentScreen = homeScreen;
       
       break;
     case EVENT_TO_HEATMAPS:
        currentScreen = heatMapScreen;
        CP5.remove("Select origin");
        
        break;
     
  }
}
