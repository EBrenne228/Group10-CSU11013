class BarChart {
  final int MAXBAR=580;
  final int CHARTGAPX=180;
  final int CHARTGAPY=50;
  final int CHARTX=800;
  final int CHARTY=600;
  final float TEXTGAP=CHARTGAPX-CHARTGAPX/4;
  final int INDENT = 12;
  //textBox
  final int TEXTBOXGAP=5;
  final int TEXTBOXX=80;
  final int TEXTBOXY=TEXTBOXGAP*8;

  PFont axisFont;

  String chartTitle;
  String yAxisTitle;

  float magArr[];
  float barx;
  float barGapx;
  float totalBar;
  float tallestBar;
  int tallestIndex;
  float multiplier;
  int barCount;
  float[] freqArr;
  int hoverCount;

  color barCol;
  color barHoverCol;
  color textBoxCol;

  boolean drawTextBox;

  BarChart(float[] freqArr) {
    barCol=color(100, 100, 250);
    barHoverCol=color(80, 200, 80);
    textBoxCol=color(250);
    drawTextBox=false;
    this.freqArr=freqArr;

    axisFont=loadFont("ProcessingSans-Regular-30.vlw");
    tallestBar=freqArr[0];
    tallestIndex=0;
    barCount=freqArr.length;
    //set tallest bar
    hoverCount=0;

    for (int i=0; i<freqArr.length; i++) {
      if (freqArr[i]>tallestBar)
        tallestBar=freqArr[i];
      tallestIndex=i;
    }
    multiplier=MAXBAR/tallestBar;
    magArr=new float[freqArr.length];

    for (int i=0; i<magArr.length; i++) {
      magArr[i]=freqArr[i]*multiplier;
    }

    totalBar=(CHARTX)/barCount;
    barx=totalBar*0.8;
    barGapx=totalBar-barx;
  }

  void barHover(float mx, float my) {
    if (drawBarChart==true) {
      for (int i=0; i<barCount; i++) {
        if (mx>(CHARTGAPX+((i+1)*barGapx)+(i*barx)) && mx<(CHARTGAPX+((i+1)*barGapx)+((i+1)*barx))
          && my>(CHARTGAPY+CHARTY-magArr[i]) && my<(CHARTGAPY+CHARTY)) {
          hoverBar=i;
          hoverBarChart=true;
          hoverCount+=1;
        }
      }
      if (hoverCount>0 && hoverBarChart==true) {
        drawTextBox=true;
      } else {
        hoverBar=-1;
        hoverBarChart=false;
      }
      hoverCount=0;
    }
  }

  void draw() {
    background(250);
    if (drawBarChart==true) {
      //x axis
      stroke(0);
      line(CHARTGAPX, CHARTGAPY+CHARTY, CHARTGAPX+CHARTX, CHARTGAPY+CHARTY);
      //y axis
      stroke(0);
      line(CHARTGAPX, CHARTGAPY, CHARTGAPX, CHARTGAPY+CHARTY);

      chartTitle = "Flights per week from JFK";
      fill(0);
      textFont(axisFont);
      textSize(22);
      text(chartTitle, CHARTGAPX+CHARTX/2, CHARTGAPY);

      yAxisTitle = "Flights";
      fill(0);
      textFont(axisFont);
      textSize(20);
      text(yAxisTitle, CHARTGAPX/3, CHARTGAPY+CHARTY/2);


      for (int i=0; i<magArr.length; i++) {
        float temp=freqArr[i];
        temp=(int)temp;
        String yAxis=""+temp;
        String xAxis="Week "+(i+1);
        color currBarCol;
        if (hoverBarChart==true && hoverBar==i) {
          currBarCol=barHoverCol;
        } else {
          currBarCol=barCol;
        }
        //individual bar
        fill (currBarCol);
        int strokeCol=(hoverBarChart==true?(hoverBar==i?0:120):0);
        stroke(strokeCol);
        rect(CHARTGAPX+((i+1)*barGapx)+(i*barx), CHARTGAPY+CHARTY-magArr[i], barx, magArr[i]);
        //y-axis
        fill(currBarCol);
        textFont(axisFont);
        textSize(13);
        text(yAxis, TEXTGAP, CHARTGAPY+CHARTY-magArr[i]);
        line(CHARTGAPX-INDENT, CHARTGAPY+CHARTY-magArr[i], CHARTGAPX, CHARTGAPY+CHARTY-magArr[i]);
        //x-axis
        fill(barCol);
        textFont(axisFont);
        textSize(15);
        text(xAxis, TEXTGAP/8+CHARTGAPX+((i+1)*barGapx)+(i*barx), CHARTGAPY+CHARTY+20);
        //textBox
        if (drawTextBox==true &&hoverBarChart==true && hoverBar==i) {
            fill (textBoxCol);
            stroke(230);
            rect(mouseX, mouseY, -TEXTBOXX, -TEXTBOXY);
            fill(0);
            textFont(axisFont);
            textSize(11);
            text(xAxis, mouseX-TEXTBOXX+TEXTBOXGAP, mouseY-4*TEXTBOXGAP);
            text(yAxisTitle+": "+yAxis, mouseX-TEXTBOXX+TEXTBOXGAP, mouseY-TEXTBOXGAP);
          }
      }
    }
  }
}
