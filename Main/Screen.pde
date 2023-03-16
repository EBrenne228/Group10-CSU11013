//Added Screen Class - Dhruv

class Screen{
  color backgroundColour;
  ArrayList <Widget> widgetList; // Defined arrayList of Widgets in Screen Class and added methods related to adding, drawing and clicking widgets - Dhruv
  
  Screen (color backgroundColour)
  {
    this.backgroundColour = backgroundColour;
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
