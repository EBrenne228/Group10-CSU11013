class Flight {
  /*for the moment I am taking all our data as strings
  we can look into interpreting as numerical values later, for 
  the purpose of Thursday, I am only concerned with
  reading our data and writing it to our flight class
  */
  
  
  
  
  String flightDate;
  String IATA_Code_Marketing_Airline;
  String flight_Number_marketing_Airline;
  String origin;
  String originCity;
  String originState;
  String originWac;
  String dest;
  String destCity;
  String destState;
  String destWac;
  String CRSDepTime;
  String depTime;
  String CRSArrTime;
  String arrTime;
  String cancelled;
  String diverted;
  String distance;
  
  Flight(String Date, String IATA, String flightNumber, String Origin, String originCity, String OriginState,
String originWac, String Dest, String destCity, String DestState,String DestWac,String CRSDepTime, String depTime, String CRSarrTime, 
String arrTime, String cancelled, String diverted, String Distance)
{
  this.flightDate = Date;
  this.IATA_Code_Marketing_Airline = IATA;
  this.flight_Number_marketing_Airline = flightNumber;
  this.origin = Origin;
  this.originCity = originCity;
  this.originState = OriginState;
  this.originWac = originWac;
  this.dest = Dest;
  this.destCity = destCity;
  this.destState = DestState;
  this.destWac = DestWac;
  this.CRSDepTime = CRSDepTime;
  this.depTime = depTime;
  this.CRSArrTime = CRSarrTime;
  this.arrTime = arrTime;
  this.cancelled = cancelled;
  this.diverted = diverted;
  this.distance = Distance;
}
  
  
 
  
}
