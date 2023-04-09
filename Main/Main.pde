import controlP5.*;
import java.util.List;
import de.bezier.data.sql.*;
import java.util.Arrays;
import java.sql.*;
import java.time.LocalDate;




ArrayList <Flight> flightList;
ArrayList <Screen> screenList;
Screen screen1;
SQLite db; // Database connection

HashMap<Integer, Flight> flightMap;
HashMap<String, Flight> airportMap;
ArrayList <Airport> airportList;
ArrayList <String> airlineList;
ArrayList <State> stateList;
BarChart bc;
PFont ourFont, widgetFont;
int [] flightsPerState = new int [50];


//chart variables
float [] flightsFromOriginweekly;
float [] flightsFromOriginDaily;
float [] flightsToDestWeekly;
float [] flightsToDestDaily;
float [] cancelledByAirlines;
String [] topAirlinesToCancel;
int countFromOriginweek1,countFromOriginweek2, countFromOriginweek3, countFromOriginweek4;
int countFromOriginDay1,countFromOriginDay2, countFromOriginDay3, countFromOriginDay4, countFromOriginDay5, countFromOriginDay6, countFromOriginDay7;
boolean drawBarChart, drawPi, drawHistogram;
boolean hoverBarChart, hoverHistogram;
int hoverCount;
boolean airline, flightNum, depAirport, depCity, depState, depWac, arrCRS, arrTime,
destAirport, destCity, destState, destWac, depCRS, depTime, flightCancel, flightDivert, distance,
byFilter, perFilter;

//widgets and buttons
Widget chartScreenButton,chartScreenButton_2,mapScreenButton, homeScreenButton,homeScreenButton_2, heatMapButton, heatMapButton_2, heatMapButton_3, flightsButton, departuresButton, arrivalsButton;
Screen homeScreen, chartScreen, heatMapScreen, pathScreen, currentScreen,arrivalsScreen,departuresScreen;

ControlP5 CP5;
DropdownList dropDownList, airlinesDDL, destinationDDL;
RadioButton radioButton;
 




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
  public America usa,arrivals, departures;
 int[] zeros = new int[50]; //dummydata for getting heatmap up
 int [] flightsFromStates = new int [50];
 int [] flightsToStates = new int [50];





void setup(){
  size(1280, 720);
  frameRate(100);
  
  db = new SQLite(this,"data/flights.sqlite"); // currently this database is using 100k flights for faster queries, once we optimise will shift to the largest dataset
  db.connect();
  thread("initialQuery"); // runs inital queries/loading of data on a separate thread from the "Animation" thread.
  
  //set up for loading screen
  nonLoopingGif = new Gif(this, "gifgit_1.gif");
  nonLoopingGif.play();
  nonLoopingGif.ignoreRepeat();
  
  
  CP5 = new ControlP5(this);
  stateList = new ArrayList<State>();
  cancelledByAirlines = new float[10];
  
  
  

  ourFont = loadFont("AmericanTypewriter-Light-150.vlw");
  widgetFont = loadFont("AmericanTypewriter-Light-30.vlw");
    
  flightMap = new HashMap<Integer, Flight>();
  airportMap = new HashMap<String, Flight>();
  airlineList = new ArrayList<String>();
    
   //defining buttons
   
   
       //home screen based buttons
   
   chartScreenButton = new Widget(575, 600, 125, 50, "  Charts", color(#18AD77), widgetFont, EVENT_TO_CHARTS);
   heatMapButton = new Widget(385, 600, 135, 50, "HeatMap", color(#18AD77), widgetFont, EVENT_TO_HEATMAPS);
   
   
   //heatMap based buttons
   
   homeScreenButton = new Widget(365, 600, 155, 50, "Home Screen", color(#18AD77), widgetFont, EVENT_TO_HOME);
   chartScreenButton_2 = new Widget(575, 600, 125, 50, "Charts", color(#18AD77), widgetFont, EVENT_TO_CHARTS);

   
    //chart screen based buttons
   homeScreenButton_2 = new Widget(50, 50, 80, 30, "Home", color(#18AD77), widgetFont, EVENT_TO_HOME);
   heatMapButton_2 = new Widget(1000, 600, 135, 50, "HeatMap", color(#18AD77), widgetFont, EVENT_TO_HEATMAPS);
      
    heatMapButton_3 = new Widget(1000,200, 135, 50, "HeatMap", color(#18AD77), widgetFont, EVENT_TO_HEATMAPS);
   
  
 //defining screens
   
   homeScreen = new Screen(color(0), true, false, false,false,false);
   chartScreen = new Screen (color(50), false, false, true,false,false);
   heatMapScreen = new Screen (color(255), false, true,false,false,false);
   arrivalsScreen = new Screen(color(255), false,false,false,true,false);
   departuresScreen = new Screen(color(255), false,false,false,false,true);
   //pathScreen = new Screen (color(0), this);
   //pathScreen = new Screen (color(0), this);
   
   
   
   currentScreen = homeScreen;
   homeScreen.addWidget(heatMapButton);
   homeScreen.addWidget(chartScreenButton);
   chartScreen.addWidget(homeScreenButton_2);
   chartScreen.addWidget(heatMapButton_2);
   heatMapScreen.addWidget(homeScreenButton);
   heatMapScreen.addWidget(chartScreenButton_2);
   
   heatMapScreen.addWidget(arrivalsButton);
   heatMapScreen.addWidget(departuresButton);
     
     
   arrivalsScreen.addWidget(departuresButton);
   arrivalsScreen.addWidget(heatMapButton_3);
   arrivalsScreen.addWidget(homeScreenButton);
   
   
   
   
   dropDownList =CP5.addDropdownList("Select Airport")
                   .setPosition(1000,50);
                   
   destinationDDL =CP5.addDropdownList("Select Airport ")
   .setPosition(1000,50);
   
   
   
   radioButton = CP5.addRadioButton("radioButton")
                    .setPosition(1050,250)
                    .setSize(60,30)
                    .setColorForeground(color(120))
                    .setColorActive(color(200))
                    .setColorLabel(color(255))
                    .setItemsPerRow(1)
                    .setSpacingColumn(50)
                    .addItem("Flights From Airports",1)
                    .addItem("Flights TO Airports",2)
                    .addItem("Cancelled Flights by Airlines", 3)
                    ;
 dropDownList.setVisible(false);
 destinationDDL.setVisible(false);
     
  currentScreen = homeScreen;
                   
 
     
  originatingAirportList = new ArrayList <Airport>();
  destinationAirportList = new ArrayList <Airport>();    
  topAirlinesToCancel = new String[10];

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
   usa.current = "Flights per state";
   usa.setColourPalette(  #f9fafb,#edf8f6,#d3eee1,  #b8e6d3,#98ddca,#014734);
   usa.setHeatMapRanges(200,100,4000,50000,80000);

  arrivals = new America(USA, states);
   arrivals.current = "Arrivals per state";
   arrivals.setColourPalette(#FFFFCC, #A1DAB4, #41B6C4, #2C7FB8, #253494,#0d1442);
    arrivals.setHeatMapRanges(100,500,2000,10000,55000);
    //arrivals.data = zeros;




    departures = new America(USA,states);
    departures.current = "Departures per state";
    departures.setColourPalette(  #ffc100, #ff9a00, #ff7400, #ff4d00,#ff0000,#b00000);
    departures.setHeatMapRanges(100,500,2000,10000,55000);


}

//void initialQuery()
//{
//     db.query("SELECT  origin FROM flights GROUP BY origin");
//     while (db.next())
//      {
//        originatingAirportList.add(new Airport(db.getString("origin")));
//        dropDownList.addItem(db.getString("origin"), 1);
//      }
      
//     //db.query("SELECT mkt_carrier FROM flights GROUP BY mkt_carrier ");
//     //while (db.next())
//     //{
//     //  airlinesDDL.addItem(db.getString("mkt_carrier"),1);
//     //  airlineList.add(db.getString("mkt_carrier"));
//     //}
//     // db.query("SELECT dest FROM flights GROUP BY dest");
//     // while (db.next())
//     // {
//     //   destinationAirportList.add(new Airport(db.getString("dest")));
//     //   //departureDDL.addItem(db.getString("dest"), 1);
//     // }
    
//    //  int hashKey = 0;
//    //  Flight temp;
//    //  db.query("SELECT * FROM flights"); 
//    //  while (db.next())
//    //  {
//    //    temp = recordToFlight(db);
//    //    flightMap.put(hashKey, temp);
//    //    hashKey++;
//    //  }
      
//      //heatMap queries
      
       

//      State tempState;
//      db.query("Select origin_state_abr FROM flights GROUP BY origin_state_abr");
//      while (db.next())
//      {
//        tempState = new State(db.getString("origin_state_abr"));
//        stateList.add(tempState);
//      }
//      stateList.remove(38);
//      stateList.remove(43);
//      stateList.remove(47);

//      for(int index = 0; index < stateList.size(); index++)
//      {
//        flightsFromStates[index] = flightsFromEachState(stateList.get(index).name);
//        flightsToStates[index] = flightsToEachState(stateList.get(index).name);
//      }
      
//      int index1 = 0;
//      db.query("SELECT mkt_carrier, COUNT(*) AS count " + "FROM flights "+ "WHERE cancelled = 1 " +  "GROUP BY mkt_carrier "+ "ORDER BY count DESC");
//      while (db.next())
//      {
//        cancelledByAirlines[index1] = db.getInt("count");
//        topAirlinesToCancel[index1] = db.getString("mkt_carrier");
//        index1++;
//      }
//      println("done");
//      for(int i = 0; i< 50; i++){
        
//        flightsPerState[i] = flightsFromStates[i] + flightsToStates[i];
        
//      }   
      
//      chartScreen.hg = new Histogram(cancelledByAirlines, topAirlinesToCancel);
//      drawHistogram = true;
//}

void initialQuery()
{
  try 
  {
    // Get the list of originating airports
    PreparedStatement originStmt = db.getConnection().prepareStatement("SELECT origin FROM flights GROUP BY origin");
    ResultSet originRs = originStmt.executeQuery();
    while (originRs.next())
    {
        String origin = originRs.getString("origin");
        airportList.add(new Airport(origin));
        dropDownList.addItem(origin, 1);
        destinationDDL.addItem(origin, 1);
    }
    println(originatingAirportList.size());
    originRs.close();
    originStmt.close();
    
    // Get the list of airlines
    //PreparedStatement airlineStmt = db.getConnection().prepareStatement("SELECT mkt_carrier FROM flights GROUP BY mkt_carrier ");
    //ResultSet airlineRs = airlineStmt.executeQuery();
    //while (airlineRs.next())
    //{
    //    String airline = airlineRs.getString("mkt_carrier");
    //    //airlinesDDL.addItem(airline, 1);
    //    airlineList.add(airline);
    //}
    //airlineRs.close();
    //airlineStmt.close();
    
    // Get the list of destination airports
  

    // Get the list of states
    PreparedStatement stateStmt = db.getConnection().prepareStatement("SELECT origin_state_abr FROM flights GROUP BY origin_state_abr");
    ResultSet stateRs = stateStmt.executeQuery();
    while (stateRs.next())
    {
        String state = stateRs.getString("origin_state_abr");
        stateList.add(new State(state));
    }
    stateRs.close();
    stateStmt.close();
    stateList.remove(38);
    stateList.remove(43);
    stateList.remove(47);
    
    // Get the list of flights for each state
    int index1 = 0;
    for (State state : stateList)
    {
        flightsFromStates[index1] = flightsFromEachState(state.name);
        flightsToStates[index1] = flightsToEachState(state.name);
        index1++;
    }
    
    //Get the list of cancelled flights by airline
    PreparedStatement cancelledStmt = db.getConnection().prepareStatement("SELECT mkt_carrier, COUNT(*) AS count FROM flights WHERE cancelled = 1 GROUP BY mkt_carrier ORDER BY count DESC");
    ResultSet cancelledRs = cancelledStmt.executeQuery();
    index1 = 0;
    while (cancelledRs.next())
    {
        cancelledByAirlines[index1] = cancelledRs.getInt("count");
        index1++;
    }
    cancelledRs.close();
    cancelledStmt.close();
    
    // Calculate the total number of flights for each state
    for (int index2 = 0; index2 < stateList.size(); index2++)
    {
        int totalFlights = flightsFromStates[index2] + flightsToStates[index2];
        flightsPerState[index2] = totalFlights;
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }
    println("done");
  
}



void draw()
{

  //bc.draw();
  //bc.barHover(mouseX, mouseY);
  
 
  if (currentScreen != chartScreen)
  {
    dropDownList.setVisible(false);
    radioButton.setVisible(false);
  }
  else if (currentScreen == chartScreen)
  {
    radioButton.setVisible(true);
  }
  currentScreen.draw();

}

void controlEvent(ControlEvent theEvent) 
{
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.
  if(theEvent.isFrom(radioButton)) {
    //print("got an event from "+theEvent.getName()+"\t");
    println("\t "+theEvent.getValue());
    //myColorBackground = color(int(theEvent.getGroup().getValue()*50),0,0);
    if (theEvent.getValue() == 1.0)
    {
      hoverBarChart = false;
      hoverCount = 0;
      drawBarChart = true;
      perFilter = true;
      byFilter = false;
      chartScreen.bc.perStr = "Day";
      depAirport = true;
      depCity = true;
      depState = true;
      depWac = true;
      byFilter = false;  
       destAirport = false;
      destCity = false;
      destState = false;
      destWac = false;
      flightCancel = false;
      dropDownList.setVisible(true);
      destinationDDL.setVisible(false);
    }
    if (theEvent.getValue() == 2.0)
    {
      hoverBarChart = false;
      hoverCount = 0;
      drawBarChart = true;
      perFilter = true;
      byFilter = false;
      chartScreen.bc.perStr = "Day";
      depAirport = false;
      depCity = false;
      depState = false;
      depWac = false;
      destAirport = true;
      destCity = true;
      destState = true;
      destWac = true;
      byFilter = false;  
      flightCancel = false;
      destinationDDL.setVisible(true);
      dropDownList.setVisible(false);
    }
    if (theEvent.getValue() == 3.0)
    {
      hoverBarChart = true;
      hoverCount = 0;
      drawBarChart = false;
      drawHistogram = true;
      hoverHistogram = true;
      perFilter = false;
      byFilter = true;
      chartScreen.hg.byStr = "Airlines";
      depAirport = false;
      depCity = false;
      depState = false;
      depWac = false;
      destAirport = false;
      destCity = false;
      destState = false;
      destWac = false;
      byFilter = true;  
      flightCancel = true;
      chartScreen.bc = new BarChart(cancelledByAirlines);
      dropDownList.setVisible(false);
    }
  }
  
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  
else if (theEvent.isController() && theEvent.isFrom(dropDownList)) {
  
      String origin = airportList.get((int)theEvent.getController().getValue()).name;
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
      
 
      
      chartScreen.bc = new BarChart(flightsFromOriginDaily);
      chartScreen.bc.depLoc = origin;
      chartScreen.bc.arrLoc = origin;
      println("event from controller : " + theEvent.getController().getValue() + " from " + theEvent.getController());
//  try {
//    String origin = originatingAirportList.get((int) theEvent.getController().getValue()).name;
//    String query = "SELECT fl_date, COUNT(*) AS total FROM flights WHERE origin = ? AND fl_date BETWEEN '2022-01-01' AND '2022-01-06' GROUP BY fl_date ORDER BY fl_date";
//    PreparedStatement stmt = db.getConnection().prepareStatement(query);
//    stmt.setString(1, origin);
//    ResultSet rs = stmt.executeQuery();

//    float[] flightsFromOriginDaily = new float[6];
//    for (int i = 0; i < flightsFromOriginDaily.length; i++) {
//        flightsFromOriginDaily[i] = 0;
//    }

//    while (rs.next()) {
//        String dateStr = rs.getString("fl_date");
//        int count = rs.getInt("total");

//        LocalDate date = LocalDate.parse(dateStr);
//        int dayOfMonth = date.getDayOfMonth();
//        flightsFromOriginDaily[dayOfMonth - 1] = count;
//    }

//    rs.close();
//    stmt.close();

//    chartScreen.bc = new BarChart(flightsFromOriginDaily);
//    chartScreen.bc.depLoc = origin;
//    chartScreen.bc.arrLoc = origin;
//    println("event from controller: " + theEvent.getController().getValue() + " from " + theEvent.getController());
//  } catch (SQLException e){
//  e.printStackTrace();
//}
} 

else if (theEvent.isController() && theEvent.isFrom(dropDownList)){
  String destination = airportList.get((int)theEvent.getController().getValue()).name;
   db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date BETWEEN '2022-01-01' AND '2022-", destination);
  
}


}

void mousePressed()
{
  int event = currentScreen.getEvent();
  switch (event)
  {
     case EVENT_TO_CHARTS:
       currentScreen = chartScreen;
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       
       break;
     case EVENT_TO_HOME:
     
       currentScreen = homeScreen;
       
       
       break;
     case EVENT_TO_HEATMAPS:
        currentScreen = heatMapScreen;
        
        
        break;
        case ARRIVALS:
    
       currentScreen = arrivalsScreen;
       
       //usa.setColourPalette(#FFFFCC, #A1DAB4, #41B6C4, #2C7FB8, #253494,#0d1442);
       //currentScreen = heatMapScreen;
       
       break;
     case DEPARTURES:
     
      currentScreen = departuresScreen;
            //usa.current = "Departures per state";
      //usa.setColourPalette(#FFFFCC, #A1DAB4, #41B6C4, #2C7FB8, #253494,#0d1442);
      //currentScreen = heatMapScreen;
      break;
     
     
  }
}
