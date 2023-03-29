class America {

  //class for the USA map
  PShape usaMap;
  ArrayList<Integer> colourCodes = new ArrayList<Integer>();  //the colour codes go into an int array, as color is a primitive type
  PShape[] usaStates; //array of state shapes from main
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
    
    for(int i = 0; i < usaStates.length;i++){
      int currentData = data[i];
      usaStates[i].disableStyle();
      fill(color(heatMapColors(currentData)));
      
      shape(usaStates[i], MAP_X, MAP_Y);
    }
  }
  
  //prints out a rectangle with the colour palette for each range, will add print statement for lower and upper ranges on the side of the rectangle later
  void rangePalette(){
    fill(#ffffff);
   rect(1011, 47,110,50);
   
   noStroke();
   fill(colourCodes.get(0));
   rect(1021,50,15,45);
   noStroke();
   fill(colourCodes.get(1));
   rect(1036,50,15,45);
   noStroke();
   fill(colourCodes.get(2));
   rect(1051,50,15,45);
   noStroke();
   fill(colourCodes.get(3));
   rect(1066,50,15,45);
   noStroke();
   fill(colourCodes.get(4));
   rect(1081,50,15,45);
   noStroke();
   fill(colourCodes.get(5));
   rect(1096,50,15,45);
   
  }
  
}
