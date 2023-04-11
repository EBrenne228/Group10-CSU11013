//Added Screen Class - Dhruv

class Screen {
  color backgroundColour;
  ArrayList <Widget> widgetList; // Defined arrayList of Widgets in Screen Class and added methods related to adding, drawing and clicking widgets - Dhruv
  BarChart bc;
  Histogram hg;
  PiChart pic;
  PApplet parent;
  DropdownList dropDownList;
  
  
  
  //attributes that define the type of screen it is
  boolean isLoading,isHeatMap, isBarChart, isarrivals, isdepartures;
  boolean drawUi = false;
  
  
  
  
  Screen (color backgroundColour, boolean loading, boolean heatMap, boolean barChart, boolean arrivals, boolean departures )
  {
    this.backgroundColour = backgroundColour;
    //this.widgetList = theButtons;
    isLoading = loading;
    isHeatMap = heatMap;
    isBarChart = barChart;
    this.isarrivals = arrivals;
    this.isdepartures = departures;
    
    if (isBarChart)
    {
      float [] floatArr = new float[3];
      bc = new BarChart(floatArr);
    }
    widgetList = new ArrayList <Widget>();
  }
  
  void draw()
  {
    
    //loading screen method
    
    if (isLoading)
    {
       image(nonLoopingGif, width/2 - nonLoopingGif.width/2, height / 2 - nonLoopingGif.height / 2);
       if( frameCount% 450 == 0) 
       {
         drawUi = true;
       }
    
    if (drawUi) 
    {    
      for (Widget widget: widgetList)
      {
        widget.draw();
      }  
    }
  }
  
//else   {      background(backgroundColour);
//    for (Widget widget: widgetList)
//    {
//      widget.draw();
//    }
//}
    else if (isHeatMap){
       usa.draw(flightsPerState);
       usa.rangePalette();
       for (Widget widget: widgetList)
       {
          widget.draw();
       }
    }
    
    else if(isarrivals){
      arrivals.draw(flightsToStates);
      arrivals.rangePalette();
      
      for (Widget widget: widgetList)
      {
        widget.draw();
      } 
    }
    
    else if (isdepartures){
      departures.draw(flightsFromStates);
      departures.rangePalette();
      
      for (Widget widget: widgetList)
      {
        widget.draw();
      }
      
    }
    
    
    else if (isBarChart){      
      background(backgroundColour);
      bc.draw();
      for (Widget widget: widgetList)
      {
        widget.draw();
      }
   }
   
   else if (drawHistogram)
   {
     hg.draw();
     for (Widget widget: widgetList)
     {
       widget.draw();
     }
   }
   
   else {
     background(backgroundColour);
     for (Widget widget: widgetList)
      {
        widget.draw();
      }
   }
   
   
   
    
  }
  
  void addWidget(Widget widget)
  {
    widgetList.add(widget);
  }
  
 
  int getEvent()
  {
     for (int index = 0; index < widgetList.size(); index++){
       Widget widget = widgetList.get(index);
       if (widget.getEvent(mouseX,mouseY) != 0)
       {
         return(widget.getEvent(mouseX, mouseY));
       }
     }
     
    
     return EVENT_NULL;
  }
}
