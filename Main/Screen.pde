//Added Screen Class - Dhruv

class Screen{
  color backgroundColour;
  ArrayList <Widget> widgetList; // Defined arrayList of Widgets in Screen Class and added methods related to adding, drawing and clicking widgets - Dhruv
  BarChart bc;
  ControlP5 CP5;
  Screen (color backgroundColour)
  {
    this.backgroundColour = backgroundColour;
    widgetList = new ArrayList <Widget>();
  }
  
  void draw()
  {
    background(backgroundColour);
    for (Widget widget: widgetList)
    {
      widget.draw();
    }
  }
  
  void addWidget(Widget widget)
  {
    widgetList.add(widget);
  }
  
  int getEvent()
  {
     for (Widget widget : widgetList)
     {
       return (widget.getEvent(mouseX, mouseY));
     }
     return EVENT_NULL;
  }
}
