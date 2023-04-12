//I added a widget class-Ellen
// Adjudted text size to fit Widgets - Dhruv
class Widget {
  int x, y, width, height;
  String label; 
  int event;
  color widgetColor, labelColor, outline =#000000;
  PFont widgetFont;

  Widget(int x,int y, int width, int height, String label,  PFont widgetFont, int event){
    this.x = x; 
    this.y = y; 
    this.width = width; 
    this.height = height;
    this.label = label; 
    this.event = event; 
    //this.widgetColor = widgetColor; 
    this.widgetColor = #5495CB;
    this.widgetFont = widgetFont;
    labelColor = color(255);
    textFont(widgetFont);
   }
   

  void draw(){
    stroke(outline);
    fill(widgetColor);
    rect(x,y,width,height,8);
    if (width == 150)
    {
      textSize(14);
    }
    if (width == 135)
    {
      textSize(16);
    }
    fill(labelColor);
    text(label, x + 10, y + height - 15);
  }
  
  int getEvent(int mX, int mY)
  {
     if(mX > x && mX < x + width && mY > y && mY < y + height)
     {
        return event;
     }
     return EVENT_NULL;
  }
    
}
