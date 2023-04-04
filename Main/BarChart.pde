class BarChart {
  //barChart
  final int MAXBAR=580;
  final int CHARTGAPX=180;
  final int CHARTGAPY=50;
  final int CHARTX=800;
  final int CHARTY=600;
  final float TEXTGAP=CHARTGAPX-CHARTGAPX/5;
  final int INDENT = 12;
  //textBox
  final int TEXTBOXGAP=5;
  final int TEXTBOXX=80;
  final int TEXTBOXY=TEXTBOXGAP*7;

  PFont axisFont;

  String chartTitle;
  String yAxisTitle;
  String xAxisTitle;

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
  int hoverBar;

  color barCol;
  color barHoverCol;
  color textBoxCol;

  boolean drawTextBox;
  String depLoc;
  String arrLoc;
  String dist;
  String arrTimeS;
  String depTimeS;
  String byStr;
  String perStr;


  BarChart(float[] freqArr, String perStr) {
    barCol=color(100, 100, 250);
    barHoverCol=color(80, 200, 80);
    textBoxCol=color(250);
    drawTextBox=false;
    this.freqArr=freqArr;
    this.perStr = perStr;

    axisFont=loadFont("ProcessingSans-Regular-30.vlw");
    tallestBar=freqArr[0];
    tallestIndex=0;
    barCount=freqArr.length;
    //set tallest bar
    hoverCount=0;
    hoverBar=-1;

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

    //set relative bar size
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

      //title
      //title pre-flight info construct
      if (flightCancel==true && flightDivert==true)
        chartTitle = "Cancelled & Diverted Flights";
      else if (flightDivert==true)
        chartTitle = "Diverted Flights";
      else if (flightCancel==true)
        chartTitle = "Cancelled Flights";
      else
      chartTitle = "Flights";

      //title post-flight info construct
      if (depAirport==true && depCity==true && depState==true && depWac==true)
        chartTitle+=" From "+depLoc;

      if (destAirport==true && destCity==true && destState==true && destWac==true)
        chartTitle+=" To "+arrLoc;
      else if (distance==true)
        chartTitle+=" "+dist;

      if (arrTime==true && arrCRS==true)
        chartTitle+=" "+arrTimeS;

      if (arrTime==true && arrCRS==true && depTime==true && depCRS==true)
        chartTitle+=" and"+depTime;
      else if (depTime==true && depCRS==true)
        chartTitle+= " "+depTimeS;

      if (airline==true)
        chartTitle+=" with the airline "+airline;
      //construct y-axis title
      yAxisTitle=chartTitle;
      //sortation of data
      if (byFilter==true) {
        xAxisTitle=byStr;
        chartTitle+=" by "+byStr;
      } else if (perFilter==true) {
        chartTitle+=" per "+perStr;
        xAxisTitle=perStr;
      }

      fill(0);
      textFont(axisFont);
      textSize(22);
      text(chartTitle, CHARTGAPX+CHARTX/2, CHARTGAPY);
      textFont(axisFont);
      textSize(20);
      text(yAxisTitle, CHARTGAPX/3, CHARTGAPY+CHARTY/2);


      for (int i=0; i<magArr.length; i++) {
        float tempf=freqArr[i];
        int temp=(int)tempf;
        String yAxis=""+temp;
        String xAxis=xAxisTitle+" "+(i+1);
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
        if (drawTextBox==true && hoverBarChart==true && hoverBar==i) {
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
