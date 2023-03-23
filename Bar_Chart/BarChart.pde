class BarChart {
  final int MAXBAR=580;
  final int CHARTGAPX=180;
  final int CHARTGAPY=50;
  final int CHARTX=800;
  final int CHARTY=600;
  

  float magArr[];
  float barx;
  float barGapx;
  float totalBar;
  float tallestBar;
  int tallestIndex;
  float multiplier;
  int barCount;

  BarChart(float[] freqArr) {
    
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
    stroke(0,200,0);
    //y axis
    line(CHARTGAPX, CHARTGAPY, CHARTGAPX, CHARTGAPY+CHARTY);
    stroke(0,200,0);
    
    for (int i=0; i<magArr.length; i++){
      rect(CHARTGAPX+((i+1)*barGapx)+(i*barx), CHARTGAPY+CHARTY-magArr[i], barx, magArr[i]);
      fill(100,100,250);
      stroke(0);
    }

  }
}
