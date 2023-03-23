class Airport{
  float xPos;
  float yPos;
  String name;
  String city;
  String state;
  ArrayList <Flight> departingFlights;
  ArrayList <Flight> arrivingFlights;
  
  Airport(String name, float xPos, float yPos)
  {
    this.name = name;
    this.xPos = xPos;
    this.yPos = yPos;
  }
  
  void setDepartureFlights(ArrayList <Flight> departureFlights)
  {  
    this.departingFlights = departureFlights;
  }
  
  void setArrivalFlights (ArrayList <Flight> arrivalFlights)
  {
    this.arrivingFlights = arrivalFlights;
  }
}
