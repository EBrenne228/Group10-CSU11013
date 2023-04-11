import java.util.List;
import java.util.Arrays;
import de.bezier.data.sql.*; //SQL library for Processing
import controlP5.*; // GUI Library

ArrayList <Flight> flightList;
SQLite db; // Database connection

HashMap<Integer, Flight> flightMap;
HashMap<String, Flight> airportMap;
ArrayList <Airport> airportList = new ArrayList <Airport>();
ArrayList <String> airlineList;
ArrayList <State> stateList;
BarChart bc;
PFont ourFont, widgetFont, glacial, glacialBig;
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
String origin = " ";
String destination = " ";

//widgets and buttons
Widget chartScreenButton,chartScreenButton_2,mapScreenButton, homeScreenButton,homeScreenButton_2, heatMapButton, heatMapButton_2, heatMapButton_3, flightsButton, departuresButton, arrivalsButton;
Screen homeScreen, chartScreen, heatMapScreen, pathScreen, currentScreen,arrivalsScreen,departuresScreen, chartScreenForAirlineData;
  // CP5 library GUI tools: Drop down lists and radio buttons
ControlP5 CP5;
DropdownList dropDownList,  destinationDDL;
RadioButton radioButton;
 




//loading screen variables

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
  frameRate(90);
  
  thread("loadFonts");   //loadind fonts on a separate thread, can run in the background while loading screen runs, easier to locate and change fonts

  db = new SQLite(this,"data/flights.sqlite");
  db.connect();
 
  
  //set up for loading screen
  nonLoopingGif = new Gif(this, "gifgit_1.gif");
  nonLoopingGif.play();
  nonLoopingGif.ignoreRepeat();
  
  
  CP5 = new ControlP5(this);
  
  
  dropDownList = CP5.addDropdownList("Select Origin Aiport")      // DropDownLists for origin airports
                   .setPosition(1100,50);
                     
  destinationDDL = CP5.addDropdownList("Select Destination Airport ")   // DropDownList for destination airports
                                 .setPosition(1100,50);
   
   
   radioButton = CP5.addRadioButton("radioButton")
                    .setPosition(1050,250)
                    .setSize(60,30)
                    .setColorForeground(color(#22DE9A))
                    .setColorActive(color(#22DE9A))
                    .setColorLabel(color(#22DE9A))
                    .setItemsPerRow(1)
                    .setSpacingColumn(50)
                    .addItem("Flights From Airports",1)
                    .addItem("Flights TO Airports",2)
                    ;
                    //.addItem("Cancelled Flights by Airlines", 3)
                    ;
                    
                    
  stateList = new ArrayList<State>();
  cancelledByAirlines = new float[10];
  
  flightMap = new HashMap<Integer, Flight>();
  airportMap = new HashMap<String, Flight>();
  airlineList = new ArrayList<String>();
    
   //initialising buttons
   
   
       //home screen based buttons
   
   chartScreenButton = new Widget(575, 600, 125, 50, "  Charts", color(#18AD77), widgetFont, EVENT_TO_CHARTS);
   heatMapButton = new Widget(385, 600, 135, 50, "HeatMap", color(#18AD77), widgetFont, EVENT_TO_HEATMAPS);
   
   
   //heatMap based buttons
   
   homeScreenButton = new Widget(365, 600, 155, 50, "Home Screen", color(#18AD77), widgetFont, EVENT_TO_HOME);
   chartScreenButton_2 = new Widget(575, 600, 125, 50, "Charts", color(#18AD77), widgetFont, EVENT_TO_CHARTS);
   arrivalsButton = new Widget(1000,200, 155,50, "Arrivals" ,color(#18AD77), widgetFont, ARRIVALS);
   departuresButton = new Widget(1000, 400, 155, 50, "Departures", color(#18AD77), widgetFont, DEPARTURES);

   
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
   
   
   
   
  
   dropDownList.setVisible(false);
   destinationDDL.setVisible(false);
     
  currentScreen = homeScreen;
                   
 
     
  airportList = new ArrayList <Airport>();
  topAirlinesToCancel = new String[10];
  
 

  //chart setup
  hoverBarChart = false;
  hoverCount = 0;
  drawBarChart = true;
  perFilter = true;
  chartScreen.bc.perStr = "Week";
  drawHistogram = true;
  hoverHistogram = true;
  drawHistogram = true;

  if(!db.connect())
  {
      println("Problem opening database");
  }
  
  // arrays for plugging into charts, initialising to avoid nullPointerExceptions
  flightsFromOriginweekly = new float[4];
  flightsFromOriginDaily = new float[6];
  flightsToDestWeekly = new float[4];   
  
  thread("initialQuery"); // runs inital queries/loading of data on a separate thread from the "Animation" thread.
  
  
//setting up heatmap 

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
  usa.current = "Flights per state";
  usa.setColourPalette(  #f9fafb,#edf8f6,#d3eee1,  #b8e6d3,#98ddca,#014734);
  usa.setHeatMapRanges(200,100,4000,50000,80000);

  arrivals = new America(USA, states);
  arrivals.current = "Arrivals per state";
  arrivals.setColourPalette(#FFFFCC, #A1DAB4, #41B6C4, #2C7FB8, #253494,#0d1442);
  arrivals.setHeatMapRanges(100,500,2000,10000,55000);

  departures = new America(USA,states);
  departures.current = "Departures per state";
  departures.setColourPalette(  #ffc100, #ff9a00, #ff7400, #ff4d00,#ff0000,#b00000);
  departures.setHeatMapRanges(100,500,2000,10000,55000);
}


void loadFonts()  // loading in fonts, called in setup
{
  glacial = createFont("glacial-indifference.regular.otf", 30);
  widgetFont = glacial;
  glacialBig = createFont("glacial-indifference.regular.otf", 45);
  ourFont = glacialBig;
}

  /*
   * intialQuery()
   * 
   *  queries for charts and heatmap being loaded in when the program is run, called in setup
   *  this method runs on a different thread than the "animation thread" allowing us to play a loading screen while the queries go through
   *
   */
    
void initialQuery()   
{
     try {
     db.query("SELECT origin FROM flights GROUP BY origin");
     while (db.next())
      {
        airportList.add(new Airport(db.getString("origin")));
        dropDownList.addItem(db.getString("origin"), 1);
        destinationDDL.addItem(db.getString("origin"), 1);
      }
      println("done1");
      
     db.query("SELECT mkt_carrier FROM flights GROUP BY mkt_carrier ");
     while (db.next())
     {
       //airlinesDDL.addItem(db.getString("mkt_carrier"),1);
       airlineList.add(db.getString("mkt_carrier"));
     }
     println("done2");
    
      
      //heatMap queries

      State tempState;
      db.query("Select origin_state_abr FROM flights GROUP BY origin_state_abr");
      while (db.next())
      {
        tempState = new State(db.getString("origin_state_abr"));
        stateList.add(tempState);
      }
      println("done3");
      stateList.remove(38);
      stateList.remove(43);
      stateList.remove(47);

      for(int index = 0; index < stateList.size(); index++)
      {
        flightsFromStates[index] = flightsFromEachState(stateList.get(index).name);
        flightsToStates[index] = flightsToEachState(stateList.get(index).name);
      }
      println("done4");
      
      int index1 = 0;
      db.query("SELECT mkt_carrier, COUNT(*) AS count " + "FROM flights "+ "WHERE cancelled = 1 " +  "GROUP BY mkt_carrier "+ "ORDER BY count DESC" + " LIMIT 10");
      while (db.next())
      {
        cancelledByAirlines[index1] = db.getInt("count");
        topAirlinesToCancel[index1] = db.getString("mkt_carrier");
        index1++;
      }
      println("done5");
      
      //int hashKey = 0;
      //Flight temp;
      //db.query("SELECT * FROM flights"); 
      //while (db.next())
      //{
      //  temp = recordToFlight(db);
      //  flightMap.put(hashKey, temp);          // storing all flights to a hashmap
      //  hashKey++;
      //}
      //println("done6");
      
      for(int i = 0; i< 50; i++){
        flightsPerState[i] = flightsFromStates[i] + flightsToStates[i];
      }   
      
     } 
     catch (NullPointerException e) 
     {
       e.printStackTrace();
     }
}


void draw()
{
 
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
  
  chartScreen.bc.barHover(mouseX, mouseY); // enables barchart hovering 
  

}

void controlEvent(ControlEvent theEvent) // built-in controlP5 method (part of the conrolListener interface), triggered when any CP5 object is pressed on.
{
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  if (theEvent.isGroup())
  {
  // to avoid an error message thrown by controlP5.
  }
  if(theEvent.isFrom(radioButton)) {
    //print("got an event from "+theEvent.getName()+"\t");
    println("\t "+theEvent.getValue());
    //myColorBackground = color(int(theEvent.getGroup().getValue()*50),0,0);
    if (theEvent.getValue() == 1.0)
    {
      hoverBarChart = true;
      hoverCount = 0;
      drawBarChart = true;
      perFilter = true;
      byFilter = false;
      chartScreen.bc.perStr = "Week";
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
      chartScreen.bc = new BarChart(flightsFromOriginweekly);
      chartScreen.bc.depLoc = origin;
    }
    if (theEvent.getValue() == 2.0)
    {
      hoverBarChart = true;
      hoverCount = 0;
      drawBarChart = true;
      drawHistogram = false;
      hoverHistogram = false;
      perFilter = true;
      byFilter = false;
      chartScreen.bc.perStr = "Week";
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
      chartScreen.bc = new BarChart(flightsToDestWeekly);
      chartScreen.bc.arrLoc = destination;
    }
    //if (theEvent.getValue() == 3.0)
    //{
    //  hoverBarChart = false;
    //  hoverCount = 0;
    //  drawBarChart = false;
    //  drawHistogram = true;
    //  hoverHistogram = true;
    //  perFilter = false;
    //  byFilter = true;
    //  chartScreen.hg.byStr = "Airlines";
    //  depAirport = false;
    //  depCity = false;
    //  depState = false;
    //  depWac = false;
    //  destAirport = false;
    //  destCity = false;
    //  destState = false;
    //  destWac = false;
    //  byFilter = true;  
    //  flightCancel = true;
    //  chartScreen.hg = new Histogram(cancelledByAirlines, topAirlinesToCancel);
    //  dropDownList.setVisible(false);
    //}
  }
  
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  
else if (theEvent.isController() && theEvent.isFrom(dropDownList)) {
  
      origin = airportList.get((int)theEvent.getController().getValue()).name;
      db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date BETWEEN '2022-01-01' AND '2022-01-07'", origin);
      flightsFromOriginweekly[0] = db.getInt("total");
      
      db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date BETWEEN '2022-01-08' AND '2022-01-14'", origin);
      flightsFromOriginweekly[1] = db.getInt("total");
      
      db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date BETWEEN '2022-01-15' AND '2022-01-21' ", origin);
      flightsFromOriginweekly[2] = db.getInt("total");
    
      db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date BETWEEN '2022-01-22' AND '2022-01-31'  ", origin);
      flightsFromOriginweekly[3]= db.getInt("total");
 
      
      chartScreen.bc = new BarChart(flightsFromOriginweekly);
      chartScreen.bc.depLoc = origin;
      println("event from controller : " + theEvent.getController().getValue() + " from " + theEvent.getController());
} 

else if (theEvent.isController() && theEvent.isFrom(destinationDDL)){
  destination = airportList.get((int)theEvent.getController().getValue()).name;
  db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date BETWEEN '2022-01-01' AND '2022-01-07'", destination);
  flightsToDestWeekly[0] = db.getInt("total");
  
  db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date BETWEEN '2022-01-08' AND '2022-01-14'", destination);
  flightsToDestWeekly[1] = db.getInt("total");
  
  db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date BETWEEN '2022-01-15' AND '2022-01-21' ", destination);
  flightsToDestWeekly[2] = db.getInt("total");

  db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date BETWEEN '2022-01-22' AND '2022-01-31'  ", destination);
  flightsToDestWeekly[3]= db.getInt("total");
    
 
      
  chartScreen.bc = new BarChart(flightsToDestWeekly);
  chartScreen.bc.arrLoc = destination;
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
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       chartScreen.bc.draw();
       break;
       
     case EVENT_TO_HOME:
       currentScreen = homeScreen;
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       break;
       
     case EVENT_TO_HEATMAPS:
       currentScreen = heatMapScreen;
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       break;
        
     case ARRIVALS:
       currentScreen = arrivalsScreen;
       break;
       //usa.setColourPalette(#FFFFCC, #A1DAB4, #41B6C4, #2C7FB8, #253494,#0d1442);
       //currentScreen = heatMapScreen;
       
     case DEPARTURES:
       currentScreen = departuresScreen;
       //usa.current = "Departures per state";
       //usa.setColourPalette(#FFFFCC, #A1DAB4, #41B6C4, #2C7FB8, #253494,#0d1442);
       //currentScreen = heatMapScreen;
       break;
  }
}
