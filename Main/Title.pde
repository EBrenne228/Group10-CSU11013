//public static class Title{
//  static String depLoc;
//  static String arrLoc;
//  static String dist;
//  static String arrTimeS;
//  static String depTimeS;
//  static String byStr;
//  static String perStr;
//  public static void yAxisTitle(String title){
//    if (flightCancel==true && flightDivert==true)
//        title = "Cancelled & Diverted Flights";
//      else if (flightDivert==true)
//        title = "Diverted Flights";
//      else if (flightCancel==true)
//        title = "Cancelled Flights";
//      else
//      title = "Flights";

//      //title post-flight info construct
//      if (depAirport==true && depCity==true && depState==true && depWac==true)
//        title+=" From "+depLoc;

//      if (destAirport==true && destCity==true && destState==true && destWac==true)
//        title+=" To "+arrLoc;
//      else if (distance==true)
//        title+=" "+dist;

//      if (arrTime==true && arrCRS==true)
//        title+=" "+arrTimeS;

//      if (arrTime==true && arrCRS==true && depTime==true && depCRS==true)
//        title+=" and"+depTime;
//      else if (depTime==true && depCRS==true)
//        title+= " "+depTimeS;

//  }
//  public static void xAxisTitle(String title){
//    if (airline==true)
//        title+=" with the airline "+airline;
//      //sortation of data
//      if (byFilter==true) {
//        title=byStr;
//        title+=" by "+byStr;
//      } else if (perFilter==true) {
//        title+=" per "+perStr;
//        title=perStr;
//      }
//  }
//}
