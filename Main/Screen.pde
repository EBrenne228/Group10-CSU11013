//Added Screen Class - Dhruv

class Screen {
  color backgroundColour;
  ArrayList <Widget> widgetList; // Defined arrayList of Widgets in Screen Class and added methods related to adding, drawing and clicking widgets - Dhruv
  BarChart bc;
  ControlP5 CP5;
  PApplet parent;
  DropdownList dropDownList;
  
  
  
  //attributes that define the type of screen it is
  boolean isLoading,isHeatMap, isBarChart;
  boolean drawUi = false;
  
  
  
  
  Screen (color backgroundColour, PApplet parent, boolean loading, boolean heatMap, boolean barChart )
  {
    this.backgroundColour = backgroundColour;
    //this.widgetList = theButtons;
    
    isLoading = loading;
    isHeatMap = heatMap;
    isBarChart = barChart;
    
    if (isBarChart)
    {
      float [] floatArr = new float[3];
      bc = new BarChart(floatArr, " ");
    }
    widgetList = new ArrayList <Widget>();
    this.parent = parent;
    CP5 = new ControlP5(this.parent);
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

     usa.draw(zeros);
    
     for (Widget widget: widgetList)
    {
      widget.draw();
    }
    
    
    }
    
    else {
      text("Number of Flights Weekly from JFK", SCREEN_X + 100, SCREEN_Y/2);
      
      background(backgroundColour);
      bc.draw();
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
     //for (Widget widget : widgetList)
     //{
     //  return (widget.getEvent(mouseX, mouseY));
     //}
     
     
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
