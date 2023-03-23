class BarChart {
  final int MAXBAR=580;
  final int CHARTGAPX=180;
  final int CHARTGAPY=50;
  final int CHARTX=1000;
  final int CHARTY=600;
  final int BARGAPX=50;
  final int BARX=120;

  float tallyW1;
  float tallyW2;
  float tallyW3;
  float tallyW4;
  float tallyW5;
  float heightWk1;
  float heightWk2;
  float heightWk3;
  float heightWk4;
  float heightWk5;
  float tallestBar;
  float multiplier;

  BarChart(float[] arr) {
    tallyW1=arr[0];
    tallyW2=arr[1];
    tallyW3=arr[2];
    tallyW4=arr[3];
    tallyW5=arr[4];
    tallestBar=tallyW1;
    //set tallest bar

    for (int i=0; i<arr.length; i++) {
      if (arr[i]>tallestBar)
        tallestBar=arr[i];
    }
    multiplier=MAXBAR/tallestBar;

    heightWk1=tallyW1*multiplier;
    heightWk2=tallyW2*multiplier;
    heightWk3=tallyW3*multiplier;
    heightWk4=tallyW4*multiplier;
    heightWk5=tallyW5*multiplier;
  }

  void draw() {
    //x axis
    line(CHARTGAPX, CHARTGAPY+CHARTY, CHARTGAPX+CHARTX, CHARTGAPY+CHARTY);
    stroke(0,200,0);
    //y axis
    line(CHARTGAPX, CHARTGAPY, CHARTGAPX, CHARTGAPY+CHARTY);
    stroke(0,200,0);

    rect(CHARTGAPX+(1*BARGAPX), CHARTGAPY+CHARTY-heightWk1, BARX, heightWk1);
    fill(200, 0, 0);
    rect(CHARTGAPX+(2*BARGAPX)+BARX, CHARTGAPY+CHARTY-heightWk2, BARX, heightWk2);
    fill(200, 0, 0);
    rect(CHARTGAPX+(3*BARGAPX)+2*BARX, CHARTGAPY+CHARTY-heightWk3, BARX, heightWk3);
    fill(200, 0, 0);
    rect(CHARTGAPX+(4*BARGAPX)+3*BARX, CHARTGAPY+CHARTY-heightWk4, BARX, heightWk4);
    fill(200, 0, 0);
    rect(CHARTGAPX+(5*BARGAPX)+4*BARX, CHARTGAPY+CHARTY-heightWk5, BARX, heightWk5);
    fill(200, 0, 0);
  }
}
