Table table;
ArrayList <Flight> flightList;
BarChart bc;
float[] sampleArr;

void setup() {

  size (1280, 720);
  background(0,0,200);
  table = loadTable("flights_full.csv", "header");
  flightList = new ArrayList <Flight>();
  for (TableRow row : table.rows()) {
    String FlightDate  = row.getString("FL_DATE");
    String IATA_Code_Marketing_Airline = row.getString("MKT_CARRIER");
    String Flight_Number_Marketing_Airline = row.getString("MKT_CARRIER_FL_NUM");
    String Origin = row.getString("ORIGIN");
    String OriginCityName = row.getString("ORIGIN_CITY_NAME");
    String OriginState = row.getString("ORIGIN_STATE_ABR");
    String OriginWac = row.getString("ORIGIN_WAC");
    String Dest = row.getString("DEST");
    String DestCityName = row.getString("DEST_CITY_NAME");
    String DestState = row.getString("DEST_STATE_ABR");
    String DestWac = row.getString("DEST_WAC");
    String CRSDepTime = row.getString("CRS_DEP_TIME");
    String DepTime = row.getString("DEP_TIME");
    String CRSArrTime = row.getString("CRS_ARR_TIME");
    String ArrTime = row.getString("ARR_TIME");
    String Cancelled = row.getString("CANCELLED");
    String Diverted = row.getString("DIVERTED");
    String Distance = row.getString("DISTANCE");
    Flight tempFlight = new Flight(FlightDate, IATA_Code_Marketing_Airline, Flight_Number_Marketing_Airline, Origin, OriginCityName, OriginState,
      OriginWac, Dest, DestCityName, DestState, DestWac, CRSDepTime, DepTime, CRSArrTime, ArrTime, Cancelled, Diverted, Distance);
    flightList.add(tempFlight);
    }
    float[] sampleArr = {7000, 8600, 11800, 13000, 1000};
    bc = new BarChart(sampleArr);
  /* System.out.printf("%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n", FlightDate, IATA_Code_Marketing_Airline, Flight_Number_Marketing_Airline,
   Origin, OriginCityName, OriginWac, Dest, DestCityName, DestWac, CRSDepTime, DepTime, CRSArrTime, ArrTime, Cancelled, Diverted, Distance); */
}
void draw(){
  bc.draw();
}
