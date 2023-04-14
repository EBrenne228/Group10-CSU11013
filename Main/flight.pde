/*
 *Flight Class by James
 */
 
public class Flight {
  String date;
  String carrierCode;
  int flightNumber;
  String originCode;
  String originCity;
  String originState;
  String destCode;
  String destCity;
  String destState;
  boolean cancelled;
  boolean diverted;
  int distance;
  
  public Flight(String date, String carrierCode, int flightNumber,
                String originCode, String originCity, String originState,
                String destCode, String destCity, String destState,
                boolean cancelled, boolean diverted,
                int distance) {
    this.date = date;
    this.carrierCode = carrierCode;
    this.flightNumber = flightNumber;
    this.originCode = originCode;
    this.originCity = originCity;
    this.originState = originState;
    this.destCode = destCode;
    this.destCity = destCity;
    this.destState = destState;
    this.distance = distance;
    this.cancelled = cancelled;
    this.diverted = diverted;
  }
  
  public String toString() {
    return String.format("%s%d: %s - %s", carrierCode, flightNumber, originCode, destCode);
  }
}
