class Histogram {
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
  int barGapxCount;
  int xCount;

  float[][] colorList;
  color barHoverCol;
  color textBoxCol;

  boolean drawTextBox;
  String byStr;
  String perStr;
  String depLoc;
  String arrLoc;
  String dist;
  String arrTimeS;
  String depTimeS;
  
  String[] barTitles;

  Histogram(float freqArr[], String[] barTitles) {
    xCount=barTitles.length;
    colorList= new float[xCount][3];
    for(int i=0; i<colorList.length; i++){
      for (int j=0; j<3; j++){
        colorList[i][j]=random(251);
      }
    }
    barHoverCol=color(255);
    textBoxCol=color(250);
    drawTextBox=false;
    this.freqArr=freqArr;
    perStr="Week";
    this.barTitles=barTitles;

    axisFont = tempFont;
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
    totalBar=(CHARTX)/magArr.length;
    barx=totalBar*0.85;
    barGapx=totalBar-barx;
  }

  void barHover(float mx, float my) 
  {
    if (drawHistogram == true) {
      for (int i = 0; i < barCount; i++) {
        float temp = (i + 1)/ xCount;
        float temp2 = ceil(temp);
        barGapxCount=(int)temp2 +1;
        if (mx > (CHARTGAPX + (barGapxCount * barGapx) + (i * barx)) && mx < (CHARTGAPX + (barGapxCount * barGapx) + ((i + 1)*barx))
          && my > (CHARTGAPY + CHARTY- magArr[i]) && my < (CHARTGAPY + CHARTY)) 
        {
          hoverBar = i;
          hoverHistogram = true;
          hoverCount += 1;
        }
      }
      if (hoverCount>0 && hoverHistogram==true) {
        drawTextBox=true;
      } else {
        hoverBar=-1;
        hoverHistogram=false;
      }
      hoverCount=0;
    }
  }
  void draw() {
    background(0);
    if (drawHistogram==true) {
      //x axis
      stroke(255);
      line(CHARTGAPX, CHARTGAPY+CHARTY, CHARTGAPX+CHARTX, CHARTGAPY+CHARTY);
      //y axis
      stroke(255);
      line(CHARTGAPX, CHARTGAPY, CHARTGAPX, CHARTGAPY+CHARTY);

      //title
      //title pre-flight info construct
      if (flightCancel==true && flightDivert==true)
        chartTitle = "Cancelled & Diverted Flights";
      else if (flightDivert==true)
        chartTitle = "Diverted Flights";
      else if (flightCancel==true)
      {
        chartTitle = "Cancelled Flights : Total Flights";
      }
      else
        chartTitle = "Largest Airlines by Number of Flights";

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
      yAxisTitle= "Flights";
      //sortation of data
      if (byFilter==true) {
        xAxisTitle=byStr;
        chartTitle+=" by "+byStr;
      } else if 
      (perFilter==true) {
        chartTitle+=" per "+perStr;
        xAxisTitle=perStr;
      }

      fill(255);
      textFont(axisFont);
      textSize(22);
      text(chartTitle, CHARTGAPX+CHARTX/3, CHARTGAPY);
      textFont(axisFont);
      textSize(20);
      text(yAxisTitle, CHARTGAPX/3, CHARTGAPY+CHARTY/2);


      for (int i=0; i<magArr.length; i++) {
        float tempf=freqArr[i];
        int temp=(int)tempf;
        String yAxis=""+temp;
        float temp4 = (i)/xCount;
        int unitCount = (int)floor(temp4) +1;
        String xAxis;
        if (flightCancel==true&&unitCount==1)
          xAxis="Cancelled Flights";
        else if (flightCancel==true&&unitCount==2)
          xAxis="Total";
        else 
          xAxis=xAxisTitle+unitCount;
          
          if (flightDivert==true&&unitCount==1)
          {
            xAxis="Airlines";
          }
          
          if (largestAirlinesFilter == true && unitCount == 1)
          {
            xAxis = "Airlines";
          }
          
        color currBarCol;

        float temp2 = i/xCount;
        float temp3 = ceil(temp2);
        barGapxCount=(int)temp3 +1;

        if (hoverHistogram==true && hoverBar==i) {
          currBarCol=barHoverCol;
        } else {
          currBarCol=color(colorList[(i+1)%xCount][0], colorList[(i+1)%xCount][1], colorList[(i+1)%xCount][2]);
        }
        //individual bar
        fill (currBarCol);
        int strokeCol=(hoverHistogram==true?(hoverBar==i?255:120):255);
        stroke(strokeCol);
        rect(CHARTGAPX+(barGapxCount*barGapx)+(i*barx), CHARTGAPY+CHARTY-magArr[i], barx, magArr[i]);
        //x-axis bars
        String currBarTitle=" ";
        for (int j=0; j<xCount; j++){
          if ((i+1)%xCount==(j+1))
            currBarTitle=barTitles[j];
          else if ((i+1)%xCount==0)
            currBarTitle=barTitles[xCount-1];
        }
        fill(255);
        textFont(axisFont);
        textSize(11);
        text(currBarTitle, CHARTGAPX+(barGapxCount*barGapx)+(i*barx), CHARTGAPY+CHARTY+INDENT*2);
        //y-axis
        fill(currBarCol);
        textFont(axisFont);
        textSize(11);
        text(yAxis, TEXTGAP - 25, CHARTGAPY+CHARTY-magArr[i] + 2);
        line(CHARTGAPX-INDENT, CHARTGAPY+CHARTY-magArr[i], CHARTGAPX, CHARTGAPY+CHARTY-magArr[i]);
        //x-axis title
        if ((i+1)%xCount==0 ) {
          fill(255);
          textFont(axisFont);
          textSize(13);
          float textLength = textWidth(xAxis);
          text(xAxis, CHARTGAPX+(barGapxCount*barGapx)+(i*barx)-(barx*0.5)-textLength, CHARTGAPY+CHARTY+INDENT*4);
        }

        //textBox
        if (drawTextBox==true && hoverHistogram==true && hoverBar==i) {
          fill (textBoxCol);
          stroke(230);
          rect(mouseX, mouseY, -TEXTBOXX, -TEXTBOXY);
          fill(0);
          textFont(axisFont);
          textSize(9);
          text(xAxis, mouseX-TEXTBOXX+TEXTBOXGAP, mouseY-4*TEXTBOXGAP);
          text(yAxisTitle+": "+yAxis, mouseX-TEXTBOXX+TEXTBOXGAP, mouseY-TEXTBOXGAP);
        }
      }
    }
  }
}
