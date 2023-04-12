class Path {
  float startX;
  float startY;
  float endX;
  float endY;
  float currentX;
  float currentY;
  float t;
  float increment;

  Path(float startX, float startY, float endX, float endY) {
    this.startX = startX;
    this.startY = startY;
    this.endX = endX;
    this.endY = endY;
    currentX = startX; // initialize currentX and currentY here
    currentY = startY;
    t = 0.0;
    increment = 0.003; // used to change the speed of animation (positive relationship), cannot be greater than 1 for lerp()
  }

  void draw() {
    stroke(#5495CB);
    strokeWeight(5);
    line(startX, startY, currentX, currentY);
    strokeWeight(1);
    fill(#1CC67B);
    circle(startX, startY, 10);
    fill(#B45445);
    circle(endX, endY, 10);
    
  }
  
 /*
  * void move()
  *
  * used to draw / animate flight path slowly
  * uses processing's in-built funciton 'lerp()' to gradually interpolate between the origin and destination
  *
  * - Dhruv
  */
  void move()
  {
    if (t < 1.0) {
    currentX = lerp(startX, endX, t);
    currentY = lerp(startY, endY, t);
    t += increment;
    println(t);
  }
}
}
