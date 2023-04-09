class Airport{
  float xPos;
  float yPos;
  String name;
  String city;
  String state;
  ArrayList <Flight> departingFlights;
  ArrayList <Flight> arrivingFlights;
  
  Airport(String name)
  {
    this.name = name;
    this.departingFlights = new ArrayList <Flight>();
    this.arrivingFlights = new ArrayList <Flight>();
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
