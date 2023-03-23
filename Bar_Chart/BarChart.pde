class BarChart {
  final int MAXBAR=580;
  final int CHARTGAPX=180;
  final int CHARTGAPY=50;
  final int CHARTX=800;
  final int CHARTY=600;
  final float TEXTGAP=CHARTGAPX-CHARTGAPX/4;
  final int INDENT = 12;

  PFont axisFont;

  float magArr[];
  float barx;
  float barGapx;
  float totalBar;
  float tallestBar;
  int tallestIndex;
  float multiplier;
  int barCount;

  BarChart(float[] freqArr) {

    axisFont=loadFont("ProcessingSans-Regular-30.vlw");
    tallestBar=freqArr[0];
    tallestIndex=0;
    barCount=freqArr.length;
    //set tallest bar

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

  void draw() {
    //x axis
    line(CHARTGAPX, CHARTGAPY+CHARTY, CHARTGAPX+CHARTX, CHARTGAPY+CHARTY);
    stroke(0);
    //y axis
    line(CHARTGAPX, CHARTGAPY, CHARTGAPX, CHARTGAPY+CHARTY);
    stroke(0);

    String chartTitle = "Flights per week from JFK"; 
    textFont(axisFont);
    textSize(22);
    text(chartTitle, CHARTGAPX+CHARTX/2, CHARTGAPY);
    
    String yAxisTitle = "Flights";
    textFont(axisFont);
    textSize(20);
    text(yAxisTitle, CHARTGAPX/3, CHARTGAPY+CHARTY/2);


    for (int i=0; i<magArr.length; i++) {
      rect(CHARTGAPX+((i+1)*barGapx)+(i*barx), CHARTGAPY+CHARTY-magArr[i], barx, magArr[i]);
      fill(100, 100, 250);
      stroke(0);
      float temp=magArr[i];
      temp=round(temp);
      String yAxis=""+temp;
      String xAxis="Week "+(i+1);

      textFont(axisFont);
      textSize(13);
      text(yAxis, TEXTGAP, CHARTGAPY+CHARTY-magArr[i]);
      line(CHARTGAPX-INDENT, CHARTGAPY+CHARTY-magArr[i], CHARTGAPX, CHARTGAPY+CHARTY-magArr[i]);

      textFont(axisFont);
      textSize(15);
      text(xAxis, TEXTGAP/8+CHARTGAPX+((i+1)*barGapx)+(i*barx), CHARTGAPY+CHARTY+20);
    }
  }
}
