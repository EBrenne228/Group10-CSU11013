import java.util.List;
import java.util.Arrays;
import de.bezier.data.sql.*; //SQL library for Processing
import controlP5.*; // GUI Library

ArrayList <Flight> flightList;
SQLite db; // Database connection

HashMap<Integer, Flight> flightMap;
HashMap<String, Airport> airportMap;
ArrayList <Airport> airportList = new ArrayList <Airport>();
ArrayList <String> dateList, airlineList, airlineListForPaths, flightNumListForPaths;
ArrayList <State> stateList;
BarChart bc;
PFont ourFont, widgetFont, glacialBig, tempFont;
int [] flightsPerState = new int [50];

 // CP5 library GUI tools: Drop down lists and radio buttons - Dhruv
ControlP5 CP5;
DropdownList dropDownList,  destinationDDL, dateDDL, airlineDDL, flightDDL;
RadioButton radioButton, weekRB, airlineChartsRB;



/*
 * Chart variables by Conor
 * Booleans for dynamic labelling, titles and hover feature of Histograms and BarCharts
 *
 */
float [] flightsFromOriginweekly;
float [] flightsFromOriginDaily;
float [] flightsToDestWeekly;
float [] flightsToDestDaily;
float [] largestAirlines, cancelledByAirlines, divertedByAirlines;
String [] largestAirlinesNames, topAirlinesToCancel, topAirlinesToDivert;
int countFromOriginweek1,countFromOriginweek2, countFromOriginweek3, countFromOriginweek4;
int countFromOriginDay1,countFromOriginDay2, countFromOriginDay3, countFromOriginDay4, countFromOriginDay5, countFromOriginDay6, countFromOriginDay7;
boolean drawBarChart, drawPi, drawHistogram;
boolean hoverBarChart, hoverHistogram;
int hoverCount;
boolean airline, flightNum, depAirport, depCity, depState, depWac, arrCRS, arrTime,
destAirport, destCity, destState, destWac, depCRS, depTime, flightCancel, flightDivert, distance,
byFilter, perFilter, largestAirlinesFilter;
int airlineChart;

 // strings for dropDownLists and dynamic queries - Dhruv
String origin = " ";
String destination = " ";
String date = " ";
String airlineForPath = " ";
String originForPath = " ";
String destForPath = " ";
String flightNumForPath = " ";
String dateForPath = " ";
String durationForPath = " ";
String flightCodeForPath = " ";
String originCityForPath = " ";
String destCityForPath = " ";



// Screens
Screen homeScreen, chartScreen, heatMapScreen, pathScreen, currentScreen,arrivalsScreen,departuresScreen, airlinesChartsScreen, pathSelectionScreen;


//widgets and buttons - Ellen
Widget chartScreenButton,chartScreenButton_2,mapScreenButton, homeScreenButton,homeScreenButton_2,homeScreenButton_3, heatMapButton, heatMapButton_2,arrivalsButton_2,
heatMapButton_3, flightsButton, departuresButton, arrivalsButton, airlinesChartsScreenButton, 
pathSelectionScreenButton, pathsScreenButton, pathGenerateButton;


//loading screen variables - Ellen
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
  
  public America usa,arrivals, departures, pathing;
  
 int[] zeros = new int[50]; //dummydata for getting heatmap up
 int [] flightsFromStates = new int [50];
 int [] flightsToStates = new int [50];




void setup(){
  size(1280, 720);
  frameRate(90);
  
  thread("loadFonts");   //loadind fonts on a separate thread, can run in the background while loading screen runs, easier to locate and change fonts - Dhruv

  db = new SQLite(this,"data/flights.sqlite");
  db.connect();
 
  
  //set up for loading screen - Ellen
  nonLoopingGif = new Gif(this, "gifgit_1.gif");
  nonLoopingGif.play();
  nonLoopingGif.ignoreRepeat();
  
  
  
  // Set up of ControlP5 UI features - Dhruv
  CP5 = new ControlP5(this);
  
  
  dropDownList = CP5.addDropdownList("Select Origin Aiport")      // DropDownLists for origin airport statrs
                   .setPosition(1050,500);
                     
  destinationDDL = CP5.addDropdownList("Select Destination Airport")   // DropDownList for destination airport stats
                                 .setPosition(1050,500);
                                 
   dateDDL = CP5.addDropdownList("Select DATE")   // DropDownList for date selection for path generator
                                 .setPosition(336,625)
                                 .setItemHeight(20)
                                 .setBarHeight(20)
                                 .setWidth(240);
                                 ;
                                 
  airlineDDL = CP5.addDropdownList("Select Airline")
                  .setPosition(576, 625)
                  
                  .setItemHeight(20)
                  .setBarHeight(20)
                  .setWidth(240);
                  ;
  flightDDL = CP5.addDropdownList("Select Flight")
                  .setPosition(816, 625)
                  .setItemHeight(20)
                  .setBarHeight(20)
                  .setWidth(240);
                  ;
                                 
   
   radioButton = CP5.addRadioButton("radioButton")
                    .setPosition(1050,300)
                    .setSize(60, 30)
                    .setColorForeground(color(#22DE9A))
                    .setColorActive(color(#22DE9A))
                    .setColorLabel(color(#22DE9A))
                    .setItemsPerRow(1)
                    .setSpacingColumn(50)
                    .addItem("Flights From Airport",1)
                    .addItem("Flights TO Airport",2)
                    ;
                  
   weekRB = CP5.addRadioButton("radioButtonWeek")
               .setPosition(1050, 100)
               .setSize(60, 30)
               .setColorForeground(color(255))
               .setColorActive(color(255))
               .setColorLabel(color(255))
               .setItemsPerRow(1)
               .setSpacingColumn(50)
               .addItem("Week 1", 1)
               .addItem("Week 2", 2)
               .addItem("Week 3", 3)
               .addItem("Week 4", 4)
               .addItem("Month", 5)
               ;
               
   airlineChartsRB = CP5.addRadioButton("radioButtonAirlines")
                        .setPosition(1050, 100)
                        .setSize(60, 30)
                        .setColorForeground(color(255))
                        .setColorActive(color(255))
                        .setColorLabel(color(255))
                        .setItemsPerRow(1)
                        .setSpacingColumn(50)
                        .addItem("10 Largest Airlines", 1)
                        .addItem("Top 5 Airlines Cancel", 2)
                        .addItem("Top 10 Airlines to Divert", 3)
                        ;
               
   // setting visibility of CP5 UI for loading and homepage - Dhruv
   dropDownList.setVisible(false);
   destinationDDL.setVisible(false);
   dateDDL.setVisible(false);
   weekRB.setVisible(false);
   airlineDDL.setVisible(false);
   flightDDL.setVisible(false);
   airlineChartsRB.setVisible(false);
   
   
   // setting up arrays to be passed to chart methods - Dhruv                                     
  stateList = new ArrayList<State>();
  cancelledByAirlines = new float[10];
  divertedByAirlines = new float [10];
  
  flightMap = new HashMap<Integer, Flight>();
  airportMap = new HashMap<String, Airport>();
  airlineList = new ArrayList<String>();
  
  airportList = new ArrayList <Airport>();
  topAirlinesToCancel = new String[5];
  topAirlinesToDivert = new String[10];
  largestAirlinesNames = new String[10];
  dateList = new ArrayList <String>();
  flightNumListForPaths = new ArrayList <String>();
  airlineListForPaths = new ArrayList <String>();
  
  
   //initialising buttons - Ellen and Dhruv
   
       //home screen based buttons

   chartScreenButton = new Widget(260, 600, 150, 50, "Airport Stats", widgetFont, EVENT_TO_CHARTS);
   airlinesChartsScreenButton = new Widget(480, 600, 150, 50, "Airline Stats", widgetFont, EVENT_TO_AIRLINES_CHARTS);
   heatMapButton = new Widget(700, 600, 135, 50, "HeatMap",  widgetFont, EVENT_TO_HEATMAPS);
   pathSelectionScreenButton = new Widget(920, 600, 180, 50, "Path Generator", widgetFont, EVENT_TO_PATH_SELECTION);
  
   
   //heatMap based buttons - Ellen
   
   homeScreenButton = new Widget(1000, 500, 155, 50, "Home Screen", widgetFont, EVENT_TO_HOME);
   chartScreenButton_2 = new Widget(1000, 600, 125, 50, "Charts", widgetFont, EVENT_TO_CHARTS);
   arrivalsButton = new Widget(1000,300, 155,50, "Arrivals" , widgetFont, ARRIVALS);
   departuresButton = new Widget(1000, 400, 155, 50, "Departures", widgetFont, DEPARTURES);
   arrivalsButton_2 = new Widget(1000, 400, 155, 50, "Arrivals", widgetFont, ARRIVALS);

   
    //chart screen based buttons - Ellen
   homeScreenButton_2 = new Widget(30, 30, 90, 40, "Home", widgetFont, EVENT_TO_HOME);
   heatMapButton_2 = new Widget(1000, 300, 135, 50, "Totals", widgetFont, EVENT_TO_HEATMAPS);
      
   heatMapButton_3 = new Widget(1000,300, 135, 50, "Totals", widgetFont, EVENT_TO_HEATMAPS);
     
     
     
  //pathScreen to mapped flight
  pathGenerateButton = new Widget (1057, 625, 150, 50, "Generate", widgetFont, EVENT_GENERATE_PATH);
  
  homeScreenButton_3 = new Widget(1150, 30, 90, 40, "Home", widgetFont, EVENT_TO_HOME);
  
 //defining screens
   
   homeScreen = new Screen(color(0), true, false, false,false,false, false);                // home screen
   chartScreen = new Screen (color(50), false, false, true,false,false, false);             // charts with airport statistics
   heatMapScreen = new Screen (color(255), false, true,false,false,false, false);           // heatmaps to display flights to and from states (total flight activity)
   arrivalsScreen = new Screen(color(255), false,false,false,true,false, false);            // heatmap screen to display flights to states
   departuresScreen = new Screen(color(255), false,false,false,false,true, false);          // heatmap screen to display flights from states
   airlinesChartsScreen = new Screen(color(0), false, false, false, false, false, false);   // charts with airline statistics
   pathSelectionScreen = new Screen(color(255), false, false, false, false, false, true);   // select flights to generate path
   currentScreen = homeScreen;                                                       // setting current screen to home screen, only current screen is drawn
                                                                                     // current screen changes to different screens as user interacts
   
   
   // Adding buttons to their screens - Ellen and Dhruv
   
   homeScreen.addWidget(heatMapButton);
   homeScreen.addWidget(chartScreenButton);
   homeScreen.addWidget(airlinesChartsScreenButton);
   homeScreen.addWidget(pathSelectionScreenButton);
   
   chartScreen.addWidget(homeScreenButton_2);
   heatMapScreen.addWidget(homeScreenButton);

   
   heatMapScreen.addWidget(arrivalsButton);
   heatMapScreen.addWidget(departuresButton);
   
   arrivalsScreen.addWidget(departuresButton);
   arrivalsScreen.addWidget(heatMapButton_3);
   arrivalsScreen.addWidget(homeScreenButton);
   
   departuresScreen.addWidget(homeScreenButton);
   departuresScreen.addWidget(heatMapButton_3);
   departuresScreen.addWidget(arrivalsButton_2);
   
   
   
   airlinesChartsScreen.addWidget(homeScreenButton_2);
   
   pathSelectionScreen.addWidget(homeScreenButton_3);
   
   currentScreen = homeScreen;
                   

  //chart setup - Conor
  hoverBarChart = false;
  hoverCount = 0;
  drawBarChart = true;
  perFilter = true;
  chartScreen.bc.perStr = "Week";
  drawHistogram = false;
  hoverHistogram = false;
  drawHistogram = false;

  if(!db.connect())
  {
      println("Problem opening database");
  }
  
  // arrays for plugging into charts, initialising to avoid nullPointerExceptions - Dhruv
  flightsFromOriginweekly = new float[4];
  flightsFromOriginDaily = new float[7];
  flightsToDestWeekly = new float[4];   
  flightsToDestDaily = new float[7];
  largestAirlines = new float[10];
  
  thread("initialQuery"); // runs inital queries/loading of data on a separate thread from the "Animation" thread. - Dhruv
  
  
 //setting up heatmap - Ellen

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
      
     // different instances of America for HeatMaps and Flight Path Generator - Ellen
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
    
    pathing = new America(USA, states);
    pathing.blankAmerica();
    pathing.current ="";
    pathing.setHeatMapRanges(0,10,20,30,40); //arbitrary numbers ignore
    
    airlinesChartsScreen.hg = new Histogram(cancelledByAirlines, topAirlinesToCancel);
}


void loadFonts()  // loading in fonts, called in setup - Dhruv
{
  tempFont = createFont("good-times-rg.otf", 20);
  widgetFont = tempFont;
  glacialBig = createFont("glacial-indifference.regular.otf", 45);
  ourFont = tempFont;
}

  /*
   * intialQuery()
   * 
   *  queries for charts and heatmap being loaded in when the program is run, called in setup
   *  this method runs on a different thread than the "animation thread" allowing us to play a loading screen while the queries go through
   *  - Dhruv
   *
   */
    
void initialQuery()   
{
     try {
     db.query("SELECT origin FROM flights GROUP BY origin");  // gets all 369 airports
     String tempAirp;
     while (db.next())
      {
        tempAirp = db.getString("origin");
        airportList.add(new Airport(tempAirp));
        dropDownList.addItem(tempAirp, 1);                
        destinationDDL.addItem(tempAirp, 1);
        airportMap.put(tempAirp, new Airport(tempAirp));    // HashMap for flight Path Generator
      }
      mapAirports();
      println("done1");
      
     db.query("SELECT mkt_carrier FROM flights GROUP BY mkt_carrier ");
     while (db.next())
     {
       airlineList.add(db.getString("mkt_carrier"));
     }
     println("done2");
    
      
      //heatMap queries

      State tempState;
      db.query("Select origin_state_abr FROM flights GROUP BY origin_state_abr");  // gets all states
      while (db.next())
      {
        tempState = new State(db.getString("origin_state_abr"));
        stateList.add(tempState);
      }
      println("done3");
      
      // 53 states being added for some reason, removing the 3 that are not supposed to be there
      stateList.remove(38);
      stateList.remove(43);
      stateList.remove(47);

      for(int index = 0; index < stateList.size(); index++)
      {
        flightsFromStates[index] = flightsFromEachState(stateList.get(index).name);
        flightsToStates[index] = flightsToEachState(stateList.get(index).name);
      }
      println("done4");
      
      
      // top 5 airlines to Cancel Flights
      int index1 = 0;
      db.query("SELECT mkt_carrier, COUNT(*) AS count " + "FROM flights "+ "WHERE cancelled = 1 " +  "GROUP BY mkt_carrier "+ "ORDER BY count DESC" + " LIMIT 5");
      while (db.next())
      {
        cancelledByAirlines[index1] = db.getInt("count");
        topAirlinesToCancel[index1] = db.getString("mkt_carrier");
        index1++;
      }
      println("done5");
      
     
      for (int index2 = 0; index2 < 5; index2++)
      {
        String tempAirl = topAirlinesToCancel[index2];
        db.query("SELECT COUNT(*) AS total from flights WHERE mkt_carrier = '%s'", tempAirl);
        cancelledByAirlines[index1] = db.getInt("total");
        index1++;
      }
      
      // top 10 airlines to divert flights
      index1 = 0;
      db.query("SELECT mkt_carrier, COUNT(*) AS count " + "FROM flights "+ "WHERE diverted = 1 " +  "GROUP BY mkt_carrier "+ "ORDER BY count DESC" + " LIMIT 10");
      while (db.next())
      {
        divertedByAirlines[index1] = db.getInt("count");
        topAirlinesToDivert[index1] = db.getString("mkt_carrier");
        index1++;
      }
      println("done6");
      
      // creating  arrayList and dropDownList for Flight Path Generator
      String tempDate;
      db.query("SELECT fl_date FROM flights GROUP BY fl_date");
      while (db.next())
      {
        tempDate = db.getString("fl_date");
        dateDDL.addItem(tempDate, 1);
        dateList.add(tempDate);
      }
      println("done7");
      
      // 10 Largest Carriers by number of flights
      index1 = 0;
      db.query("SELECT mkt_carrier, COUNT(*) AS count " + "FROM flights " +  "GROUP BY mkt_carrier "+ "ORDER BY count DESC" + " LIMIT 10");
      while (db.next())
      {
        largestAirlines[index1] = db.getInt("count");
        largestAirlinesNames[index1] = db.getString("mkt_carrier");
        index1++;
      }
      println("done8");
      
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
  currentScreen.draw();   // points to a different screen as user interacts, starts at homescreen
 
  if (currentScreen != chartScreen)
  {
    dropDownList.setVisible(false);
    radioButton.setVisible(false);
    weekRB.setVisible(false);
  }
  else if (currentScreen == chartScreen)
  {
    weekRB.setVisible(true);
  }
 
  chartScreen.bc.barHover(mouseX, mouseY); // enables barchart hovering 
  airlinesChartsScreen.hg.barHover(mouseX, mouseY); // enables histogram hovering
}

  /*
   *
   * controlEvent(ControlEvent theEvent)
   *
   *  built-in controlP5 method (part of the conrolListener interface)
   *  Called when any CP5 object is interacted with
   *  
   *  Capitalised on this to make the appication more interactive overall, especially in relation to dynamic charts
   *  and queries with varying parameters
   *
   *  - Dhruv  
   *
   */
void controlEvent(ControlEvent theEvent) 
{ 
  if (theEvent.isGroup())
  {
     // to avoid an error message thrown by controlP5.
     println(theEvent.getValue());
  }
  
  // everytime radioButton is clicked it returns an integer corresponding to each item.
  if(theEvent.isFrom(radioButton)) {
    
    println("\t "+theEvent.getValue());

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
  }
  
  
  if(theEvent.isFrom(weekRB)) {
     if (theEvent.getValue() == 1.0)
     {
       airlineChart = AIRL_CHART_WEEK_1;
     }
     else if (theEvent.getValue() == 2.0)
     {
       airlineChart = AIRL_CHART_WEEK_2;
     }
     else if (theEvent.getValue() == 3.0)
     {
       airlineChart = AIRL_CHART_WEEK_3;
     }
     else if (theEvent.getValue() == 4.0)
     {
       airlineChart = AIRL_CHART_WEEK_4;
     }
      else if (theEvent.getValue() == 5.0)
     {
       airlineChart = AIRL_CHART_MONTH;
     }
     radioButton.setVisible(true);
  }
  
   if(theEvent.isFrom(airlineChartsRB)) {
     if (theEvent.getValue() == 1.0)
     {
       airlinesChartsScreen.hg = new Histogram(divertedByAirlines, topAirlinesToDivert);
       drawHistogram = true;
       hoverHistogram = true;
       byFilter = false;
       perFilter = false;
       flightCancel = false;
       flightDivert = false;
       largestAirlinesFilter = true;
      
     }
     else if (theEvent.getValue() == 2.0)
     {
        airlinesChartsScreen.hg = new Histogram(cancelledByAirlines, topAirlinesToCancel);
       drawHistogram = true;
       hoverHistogram = true;
       byFilter = false;
       perFilter = false;
       flightCancel = true;
       flightDivert = false;
       largestAirlinesFilter = false;
     }
     else if (theEvent.getValue() == 3.0)
     {
        airlinesChartsScreen.hg = new Histogram(divertedByAirlines, topAirlinesToDivert);
        drawHistogram = true;
       hoverHistogram = true;
       byFilter = false;
       perFilter = false;
       flightCancel = false;
       flightDivert = true;
       largestAirlinesFilter = false;
     }
  }
  
  else if (theEvent.isController() && theEvent.isFrom(dropDownList)) {
  
      origin = airportList.get((int)theEvent.getController().getValue()).name;  // the arrayList and dropDownList have items in the same order
      largestAirlinesFilter = false;
      switch (airlineChart)
      {
        case AIRL_CHART_WEEK_1:
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date  = '2022-01-01' ", origin);
          flightsFromOriginDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-02' ", origin);
          flightsFromOriginDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-03' ", origin);
          flightsFromOriginDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-04' ", origin);
          flightsFromOriginDaily[3]= db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-05'", origin);
          flightsFromOriginDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-06' ", origin);
          flightsFromOriginDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-07' ", origin);
          flightsFromOriginDaily[6]= db.getInt("total");
          
          chartScreen.bc = new BarChart(flightsFromOriginDaily);
          chartScreen.bc.depLoc = origin;
          chartScreen.bc.perStr = "Day";
          break;
          
          case AIRL_CHART_WEEK_2:
        db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date  = '2022-01-08' ", origin);
          flightsFromOriginDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-09' ", origin);
          flightsFromOriginDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-10' ", origin);
          flightsFromOriginDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-11' ", origin);
          flightsFromOriginDaily[3]= db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-12'", origin);
          flightsFromOriginDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-13' ", origin);
          flightsFromOriginDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-14' ", origin);
          flightsFromOriginDaily[6]= db.getInt("total");
          
          chartScreen.bc = new BarChart(flightsFromOriginDaily);
          chartScreen.bc.depLoc = origin;
          chartScreen.bc.perStr = "Day";
          break;
          
         case AIRL_CHART_WEEK_3:
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date  = '2022-01-15' ", origin);
          flightsFromOriginDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-16' ", origin);
          flightsFromOriginDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-17' ", origin);
          flightsFromOriginDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-18' ", origin);
          flightsFromOriginDaily[3]= db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-19'", origin);
          flightsFromOriginDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-20' ", origin);
          flightsFromOriginDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-21' ", origin);
          flightsFromOriginDaily[6]= db.getInt("total");
          
          chartScreen.bc = new BarChart(flightsFromOriginDaily);
          chartScreen.bc.depLoc = origin;
          chartScreen.bc.perStr = "Day";
          break;
          
         case AIRL_CHART_WEEK_4:
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date  = '2022-01-22' ", origin);
          flightsFromOriginDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-23' ", origin);
          flightsFromOriginDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-24' ", origin);
          flightsFromOriginDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-25' ", origin);
          flightsFromOriginDaily[3]= db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-26'", origin);
          flightsFromOriginDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-27' ", origin);
          flightsFromOriginDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE origin = '%s' AND fl_date = '2022-01-28' ", origin);
          flightsFromOriginDaily[6]= db.getInt("total");
          
          chartScreen.bc = new BarChart(flightsFromOriginDaily);
          chartScreen.bc.depLoc = origin;
          chartScreen.bc.perStr = "Day";
          break;
          
        case AIRL_CHART_MONTH:
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
          chartScreen.bc.perStr = "week";
          break;
      }
      println("event from controller : " + theEvent.getController().getValue() + " from " + theEvent.getController());
  } 

  else if (theEvent.isController() && theEvent.isFrom(destinationDDL)){
    destination = airportList.get((int)theEvent.getController().getValue()).name;
       largestAirlinesFilter = false;
      switch (airlineChart)
      {
        case AIRL_CHART_WEEK_1:
         db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date  = '2022-01-01' ", destination);
          flightsToDestDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-02' ", destination);
          flightsToDestDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-03' ", destination);
           flightsToDestDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-04' ", destination);
           flightsToDestDaily[3] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-05'", destination);
          flightsToDestDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-06' ", destination);
          flightsToDestDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-07' ", destination);
          flightsToDestDaily[6] = db.getInt("total");
          
          chartScreen.bc = new BarChart(flightsToDestDaily);
          chartScreen.bc.arrLoc = destination;
          chartScreen.bc.perStr = "Day";
          break;
          
          case AIRL_CHART_WEEK_2:
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date  = '2022-01-08' ", destination);
          flightsToDestDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-09' ", destination);
          flightsToDestDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-10' ", destination);
          flightsToDestDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-11' ", destination);
          flightsToDestDaily[3]= db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-12'", destination);
          flightsToDestDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-13' ", destination);
          flightsToDestDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-14' ", destination);
          flightsToDestDaily[6]= db.getInt("total");
          
          
          chartScreen.bc = new BarChart(flightsToDestDaily);
          chartScreen.bc.arrLoc = destination;
          chartScreen.bc.perStr = "Day";
          break;
          
         case AIRL_CHART_WEEK_3:
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date  = '2022-01-15' ", destination);
          flightsToDestDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-16' ", destination);
          flightsToDestDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-17' ", destination);
          flightsToDestDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-18' ", destination);
          flightsToDestDaily[3]= db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-19'", destination);
          flightsToDestDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-20' ", destination);
          flightsToDestDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-21' ", destination);
          flightsToDestDaily[6]= db.getInt("total");
          
          chartScreen.bc = new BarChart(flightsToDestDaily);
          chartScreen.bc.arrLoc = destination;
          chartScreen.bc.perStr = "Day";
          break;
          
         case AIRL_CHART_WEEK_4:
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date  = '2022-01-22' ", destination);
          flightsToDestDaily[0] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-23' ", destination);
          flightsToDestDaily[1] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-24' ", destination);
          flightsToDestDaily[2] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-25' ", destination);
          flightsToDestDaily[3]= db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-26'", destination);
          flightsToDestDaily[4] = db.getInt("total");
          
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-27' ", destination);
          flightsToDestDaily[5] = db.getInt("total");
        
          db.query("SELECT COUNT(*) AS total FROM flights WHERE dest = '%s' AND fl_date = '2022-01-28' ", destination);
          flightsToDestDaily[6]= db.getInt("total");
          
          chartScreen.bc = new BarChart(flightsToDestDaily);
          chartScreen.bc.arrLoc = destination;
          chartScreen.bc.perStr = "Day";
          break;
          
        case AIRL_CHART_MONTH:
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
         chartScreen.bc.perStr = "week";
         println("event from controller : " + theEvent.getController().getValue() + " from " + theEvent.getController());
    
      }
    
    
  }
  
  else if (theEvent.isController() && theEvent.isFrom(dateDDL)){
    airlineDDL.clear();
    date = dateList.get((int)theEvent.getController().getValue());
    println(date);
    db.query("SELECT mkt_carrier FROM flights WHERE fl_date = '%s' GROUP BY mkt_carrier ", date);
    String tempAirline;
    airlineDDL.clear();
    flightDDL.clear();
    while(db.next())
    {
      tempAirline = db.getString("mkt_carrier");
      airlineDDL.addItem(tempAirline, 1);
      airlineListForPaths.add(tempAirline);
    }
    airlineDDL.setVisible(true);
  }
  
  else if (theEvent.isController() && theEvent.isFrom(airlineDDL)){
    
    flightDDL.clear();
    airlineForPath = airlineListForPaths.get((int)theEvent.getController().getValue());
    db.query("SELECT * FROM flights WHERE fl_date = '%s' AND mkt_carrier = '%s' ", date, airlineForPath);
    String tempFlight;
    while(db.next())
    {
      tempFlight = String.format("%s %s : %s (%s) to %s (%s)", db.getString("mkt_carrier"), db.getString("mkt_carrier_fl_num"), db.getString("origin"), 
      db.getString("origin_city_name"), db.getString("dest"), db.getString("dest_city_name") );
      flightDDL.addItem(tempFlight, 1);
      flightNumListForPaths.add(db.getString("mkt_carrier_fl_num"));
    }
    flightDDL.setVisible(true);
  }
  
  else if (theEvent.isController() && theEvent.isFrom(flightDDL)){
    flightNumForPath = flightNumListForPaths.get((int)theEvent.getController().getValue());
    db.query("SELECT * FROM flights WHERE fl_date = '%s' AND mkt_carrier = '%s' AND mkt_carrier_fl_num = '%s' LIMIT 1 ", date, airlineForPath, 
             flightNumForPath);
    originForPath = db.getString("origin");
    destForPath = db.getString ("dest");
    durationForPath = db.getString("duration");
    originCityForPath = db.getString("origin_city_name");
    destCityForPath = db.getString("dest_city_name");
    dateForPath = date;
    flightCodeForPath = airlineForPath + flightNumForPath;
    pathSelectionScreen.addWidget(pathGenerateButton);
    println("event from controller : " + theEvent.getController().getValue() + " from " + theEvent.getController());
  }
}

  /*
   *
   * mousePressed()
   *
   * called everytime mouse is clicked or "pressed"
   * implemented to interact with UI widgets
   * gets events from getEvent() method of screens
   *
   * - Dhruv and Ellen
   * 
   */
void mousePressed()
{
  int event = currentScreen.getEvent();
  
   if (event!= EVENT_TO_PATH_SELECTION && (pathSelectionScreen.widgetList.size() ==  2)){
    pathSelectionScreen.widgetList.remove(1);
  }
  switch (event)
  {
     case EVENT_TO_CHARTS:
       currentScreen = chartScreen;
        perFilter = true;
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       weekRB.setVisible(true);
       chartScreen.bc.draw();
       dateDDL.setVisible(false);
       airlineDDL.setVisible(false);
       flightDDL.setVisible(false);
       radioButton.setVisible(false);
       airlineChartsRB.setVisible(false);
       flightCancel = false;
       drawHistogram = false;
       break;
       
     case EVENT_TO_HOME:
       currentScreen = homeScreen;
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       weekRB.setVisible(false);
       dateDDL.setVisible(false);
       airlineDDL.setVisible(false);
       flightDDL.setVisible(false);
       airlineChartsRB.setVisible(false);
       drawHistogram = false;
       break;
       
     case EVENT_TO_HEATMAPS:
       currentScreen = heatMapScreen;
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       weekRB.setVisible(false);
       dateDDL.setVisible(false);
       airlineDDL.setVisible(false);
       flightDDL.setVisible(false);
       airlineChartsRB.setVisible(false);
       drawHistogram = false;
       break;
        
     case ARRIVALS:
       currentScreen = arrivalsScreen;
       dateDDL.setVisible(false);
       airlineDDL.setVisible(false);
       flightDDL.setVisible(false);
       airlineChartsRB.setVisible(false);
       drawHistogram = false;
       break;
       
     case DEPARTURES:
       currentScreen = departuresScreen;
       dateDDL.setVisible(false);
       airlineDDL.setVisible(false);
       flightDDL.setVisible(false);
       airlineChartsRB.setVisible(false);
       drawHistogram = false;
       break;
       
     case EVENT_TO_AIRLINES_CHARTS:
       currentScreen = airlinesChartsScreen;
       airlinesChartsScreen.hg.yAxisTitle = "flights";
       airlinesChartsScreen.hg = new Histogram(cancelledByAirlines, topAirlinesToCancel);
       airlineChartsRB.setVisible(true);
       break;
       
     case EVENT_TO_PATH_SELECTION:
       currentScreen = pathSelectionScreen;
       byFilter = false;
       perFilter = false;
       airlineChartsRB.setVisible(false);
       dateDDL.setVisible(true);
       dropDownList.setVisible(false);
       destinationDDL.setVisible(false);
       weekRB.setVisible(false);
       drawHistogram = false;
       break;
       
     case EVENT_GENERATE_PATH:
       float Ox = airportMap.get(originForPath).xPos;
       float Oy = airportMap.get(originForPath).yPos;
       float Dx = airportMap.get(destForPath).xPos;
       float Dy = airportMap.get(destForPath).yPos;
      
      pathing.doPath = true;
        pathing.getPath(originForPath, Ox,Oy, destForPath,Dx, Dy,dateForPath, flightCodeForPath,durationForPath, originCityForPath, destCityForPath);
        break;
      case EVENT_NULL:
        println(mouseX, mouseY);
  }
}
