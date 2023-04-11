public class PiChart {
  final int RADIUS=275;
  final int PIX = 600;
  final int PIY = 350;
  final int INFOSTART=1200;
  final int INDENT=20;
  final float AREA = PI*RADIUS*RADIUS;
  final int COLORBOX = 15;

  color currSliceColor;
  PFont textFont;

  int sliceCount;
  float totalFreq;
  float startAngle;
  float stopAngle;

  float[] freqArr; //frequency array
  float[] propArr; //proportionate angle array
  float[] cumPropArr; //cumulative proportionate angle array
  float[] percArr; //percentage array
  String[] sliceTitles;
  float[][] colorList;



  PiChart(float[] freqArr, String[] sliceTitles) {
    textFont=loadFont("ProcessingSans-Regular-30.vlw");
    this.freqArr=freqArr;
    this.sliceTitles=sliceTitles;
    sliceCount=freqArr.length;
    totalFreq=0;
    cumPropArr = new float[freqArr.length];
    propArr = new float[freqArr.length];
    percArr = new float[freqArr.length];

    for (int i=0; i<sliceCount; i++) {
      totalFreq+=freqArr[i];
    }
    for (int i=0; i<sliceCount; i++) {
      float temp =10000*freqArr[i]/totalFreq;
      temp=round(temp);
      percArr[i]=(temp/100);
    }
    for (int i=0; i<sliceCount; i++) {
      propArr[i]=2*PI*freqArr[i]/totalFreq; //angle of each slice
      cumPropArr[i]=propArr[i];
      for (int j=0; j<i; j++) {
        cumPropArr[i]+=propArr[j];
      }
    }
    colorList= new float[sliceCount][3];
    for (int i=0; i<colorList.length; i++) {
      for (int j=0; j<3; j++) {
        colorList[i][j]=random(251);
      }
    }
  }

  void draw() {
    if (drawPi==true) {
      fill(250);
      ellipse(PIX, PIY, 2*RADIUS, 2*RADIUS);
      // slice time
      for (int i=0; i<sliceCount; i++) {
        currSliceColor=color(colorList[i][0], colorList[i][1], colorList[i][2]);
        if (i==0) {
          startAngle=0;
          stopAngle=cumPropArr[i];
        } else {
          startAngle=cumPropArr[i-1];
          stopAngle=cumPropArr[i];
        }
        if (stopAngle>2*PI)
          stopAngle=2*PI;
        fill(currSliceColor);
        stroke(0);
        arc(PIX+i*00, PIY, 2*RADIUS, 2*RADIUS, startAngle, stopAngle);
        if (i!=sliceCount-1) {
          float theta = cumPropArr[i];
          float height=RADIUS*tan(theta);
          float hypot=height/sin(theta);
          float adjHeight=height*RADIUS/hypot;
          float width=RADIUS*RADIUS/hypot;
          fill(0);
          line(PIX, PIY, PIX+width, PIY+adjHeight);
        }
        
        String title = (i<sliceTitles.length?sliceTitles[i]:"Unknown");
        fill(currSliceColor);
        stroke(0);
        rect(INFOSTART, (1.4+i)*INDENT, COLORBOX, COLORBOX);
        fill(0);
        textFont(textFont);
        textSize(13);
        text(title, INFOSTART+INDENT, ((2)+i)*INDENT);
      }
      //base line
      fill(0);
      line(PIX, PIY, PIX+RADIUS, PIY);
    }
  }
}
