public class America {

  //class for the USA map
  PShape usaMap;
  ArrayList<Integer> colourCodes = new ArrayList<Integer>();  //the colour codes go into an int array, as color is a primitive type
  PShape[] usaStates; //array of state shapes from main
  String current;
  Path flightPath;
  boolean doPath = false;

  
  
  
  America(PShape usa, PShape[] states){  //constructor, takes country map and states map
    usaMap = usa;
    usaStates = states;
    
  }
  int range1,range2,range3,range4,range5; //declaring variables for each range

 
 void setColourPalette(int colourCode, int colourCode1, int colourCode2, int colourCode3, int colourCode4, int colourCode5){ 
   //set your colour palette for each range (first one being for if a value is 0)
   
     colourCodes.add(colourCode);
     colourCodes.add(colourCode1);
     colourCodes.add(colourCode2);
     colourCodes.add(colourCode3);
     colourCodes.add(colourCode4);
     colourCodes.add(colourCode5);
 }
  
 
  
  
  void blankAmerica(){
    for(int i = 0; i <6; i++){
      colourCodes.add(#f7f7f7);
    }
  }
  
  
  int [] emptyData(){
    int[] zeros = new int[50];
    Arrays.fill(zeros, 0);
    
    return zeros;
  }

  void setHeatMapRanges(int range1, int range2, int range3, int range4, int range5) {
    //set the range boundaries 
    this.range1 = range1;
    this.range2 = range2;
    this.range3 = range3;
    this.range4 = range4;
    this.range5 = range5;
  }



// takes a numeric value, returns a colour hex code based on the user submitted range thats within
public int heatMapColors(int dataPoint){
      //ArrayList<color> stateColours = new ArrayList<color>();
      //for (int i = 0; i < data.length; i ++) {
      int currentData = dataPoint;
      
      currentData = dataPoint;
         if ( (0 < currentData )&& (currentData <= range1 ))return colourCodes.get(1); //#fff33b
         else if ((range1 < currentData) && (currentData <= range2) ) return colourCodes.get(2);//#fdc70c
         else if ((range2 < currentData && currentData <= range3)) return colourCodes.get(3); //#f3903f
         else if((range3 < currentData && currentData <= range4)) return colourCodes.get(4) ; //#ed683c
         else if ((range5 < currentData && currentData <= range5)) return colourCodes.get(5); //#e93e3a
         else {return colourCodes.get(0);} //#f8fad7
}


 



/*draws the USA, colours in each state based on 
 data within corresponding index of the data array, to the states array
 
 use stroke() command before calling in main, if youd like to change the outline colour between states
 */
  void draw(int data[]) {
    shape(usaMap, MAP_X, MAP_Y);
    if (doPath)
    {
       textSize(12);
       text(current, 900, 300);
    }
    else
    {
      text(current, 640, 50);
    }
    
    
    
  
    
    for(int i = 0; i < usaStates.length;i++){
      int currentData = data[i];
      usaStates[i].disableStyle();
      fill(color(heatMapColors(currentData)));
      
      shape(usaStates[i], MAP_X, MAP_Y);
    }
    
    
    //ellipse(200, 200, 120, 120);
    
    if(doPath) 
    {
    
      this.flightPath.draw();
      this.flightPath.move();
    }
    
    
    
    
    
  }
  
  //prints out a rectangle with the colour palette for each range, will add print statement for lower and upper ranges on the side of the rectangle later
  void rangePalette(){
 fill(#ffffff);
   //rect(1011, 47,110,50);
   
   noStroke();
   fill(colourCodes.get(0));
  // rect(1021,50,15,45);
   fill(255);
   text("0", 1000,65);
   //noStroke();
   fill(colourCodes.get(1));
  // rect(1036,50,15,45);
   text(range1, 1000,85);
   noStroke();
   fill(colourCodes.get(2));
   //rect(1051,50,15,45);
   text(range2, 1000, 105);
   noStroke();
   fill(colourCodes.get(3));
   //rect(1066,50,15,45);
   text(range3, 1000, 125);
   noStroke();
   fill(colourCodes.get(4));
  // rect(1081,50,15,45);
   text(range4, 1000, 145);
   noStroke();
   fill(colourCodes.get(5));
   //rect(1096,50,15,45);
   text(range5, 1000, 165);
   
   stroke(0);
   
   
   fill(#ffe3ab);
    text("WA" ,150,71);
    text("OR", 123, 141);
    text("ID", 225, 159);
    text("MT", 311, 104);
    text("ND", 423,115);
    text("SD", 435,176);
    text("MN", 515, 140);
    text("IA", 545, 218);
    text("NE",435,236);
    text("WY", 315, 192);
    text("WI", 580, 163);
    text("IL", 618, 253);
    text("IN", 662, 250);
    text("MI", 686, 188);
    text("OH", 710, 243);
    text("PA", 794, 221);
    text("NY", 820, 162);
    text("VT", 845, 102);
    text("NH",870, 141);
    text("ME", 895, 102);
    text("MA", 923, 158);
    text("RI", 926,185);
    text("CT",917,208);
    text("NJ", 874, 222);
    text("MD", 821, 241);
    text("DC", 865, 288);
    text("DE",864,249);
    text("VA", 804, 286);
    text("WV",758,274);
    text("KY", 696, 302);
    text("NC", 801, 328);
    text("TN",678,338);
    text("MO",558,296);
    text("KS", 469, 291);
    text("CO", 343, 277);
    text("UT", 257, 258);
    text("NV", 173, 239);
    text("CA",103,281);
    text("AZ", 243, 359);
    text("NM", 334, 371);
    text("TX", 461, 444);
    text("AK", 253, 526);
    text("HI", 72, 517);
    text("OK", 483, 352);
    text("AR", 571, 371);
    text("LA", 567, 449);
    text("MS", 625, 416);
    text("AL", 674, 404);
    text("GA", 746,406);
    text("FL", 776, 479);
    text("SC", 777, 370);
    stroke(0);
  }
  
  void stateNames ()
  {
    fill(#5495CB);
    text("WA" ,150,71);
    text("OR", 123, 141);
    text("ID", 225, 159);
    text("MT", 311, 104);
    text("ND", 423,115);
    text("SD", 435,176);
    text("MN", 515, 140);
    text("IA", 545, 218);
    text("NE",435,236);
    text("WY", 315, 192);
    text("WI", 580, 163);
    text("IL", 618, 253);
    text("IN", 662, 250);
    text("MI", 686, 188);
    text("OH", 710, 243);
    text("PA", 794, 221);
    text("NY", 820, 162);
    text("VT", 845, 102);
    text("NH",870, 141);
    text("ME", 895, 102);
    text("MA", 923, 158);
    text("RI", 926,185);
    text("CT",917,208);
    text("NJ", 874, 222);
    text("MD", 821, 241);
    text("DC", 865, 288);
    text("DE",864,249);
    text("VA", 804, 286);
    text("WV",758,274);
    text("KY", 696, 302);
    text("NC", 801, 328);
    text("TN",678,338);
    text("MO",558,296);
    text("KS", 469, 291);
    text("CO", 343, 277);
    text("UT", 257, 258);
    text("NV", 173, 239);
    text("CA",103,281);
    text("AZ", 243, 359);
    text("NM", 334, 371);
    text("TX", 461, 444);
    text("AK", 253, 526);
    text("HI", 72, 517);
    text("OK", 483, 352);
    text("AR", 571, 371);
    text("LA", 567, 449);
    text("MS", 625, 416);
    text("AL", 674, 404);
    text("GA", 746,406);
    text("FL", 776, 479);
    text("SC", 777, 370);
    stroke(0);
  }
  
  /*
   * void getPath
   *
   * Parameters: flight origin and destination airports, their X and Y coordinates
   * Generates a Flight path through interpolation using the 'move()' method from the Path Class
   * 
   * Parameters: flight origin and destination airports, their cities and states, flight code, flight date and flight duration
   * Prints these out on the Screen.
   * 
   * - Dhruv
   */
  
  void getPath( String origin, float Ox, float Oy, String dest, float Dx, float Dy, String date, String flightCode, String duration, 
               String originCity, String destCity){
  
  String combined = String.format("%s on %s\n\n%s (%s)  to  %s (%s) \n\nDuration: %s", flightCode, date, origin, originCity, dest, destCity, duration);
  this.current = combined;
  fill(0);
  
  this.flightPath = new Path(Ox, Oy, Dx, Dy);
  
  }
}
  
