/*
reffernce 
describing plot area with axis: http://yoppa.org/bma10/1250.html
implement queue: http://www.atmarkit.co.jp/ait/articles/1010/14/news127.html
*/

import processing.serial.*;

Serial myPort;

/*
This reference voltage V_ref is more accurate than one generated by microcontroller.
And you can make that more accurate by measuring the voltage between VA and GND
and use that value to replace 3.00
*/
int data;           // digital value from adc of Arduino
int cnt = 0;        // count of plot area
float V_ref = 3.0;  // reference voltage of GROVE I2C ADC
float V_cc = 5.1;   // supply voltage on ammeter ACS714(-5A to +5A)
float V_out;        // analog output of ammeter
float amp;          // measured current

float plotX1, plotY1;  // define graphic area
float plotX2, plotY2;  // 
float labelX, labelY;  // position of each labels

float dataMin = -0.1;            // 
float dataMax = 0.1;             // 
float dataInterval = 0.05;       // 
float dataIntervalMinor = 0.01;  // 

color col;
PFont plotFont;



void setup()
{
  size(720, 405);

  plotX1 = 120; 
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70;
  labelY = height - 25;

  col = color(255, 127, 31);
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);
  frameRate(50);
  smooth();

  initGraph();

  // serch a valid port
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
}

void draw()
{
  // receive 2 byte integer with header such as 'H1690'
  if (myPort.available() >= 3) {
    if (myPort.read() == 'H') {
      int high = myPort.read();
      int low = myPort.read();
      data = high*256 + low;
      V_out = data*2*V_ref/4096;
      amp = (V_out - V_cc/2)/0.185;

      float tx = map(cnt, 0, width, plotX1, plotX2);
      float ty = map(amp, dataMin, dataMax, plotY2, plotY1);

      drawAxisLabels();
      drawVerticalLabels();
      drawHorizontalLabels();
      drawEllipse(tx, ty);
      // println(data);
      // println(V_out);
      if (cnt > width) {
        initGraph();
      }
      cnt++;
    }
  }
}

void initGraph() {
  fill(255);
  background(220);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);
  cnt = 0;
}

void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);

  textAlign(CENTER, CENTER);
  text("Ampere [A]", labelX, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Index", (plotX1+plotX2)/2, labelY);
}

void drawVerticalLabels() {
  fill(0);
  textSize(10);

  stroke(128);
  strokeWeight(1);

  for (float v = dataMin; v <= dataMax; v += dataIntervalMinor) {
    if (round(v % dataIntervalMinor) == 0) {
      float y = map(v, dataMin, dataMax, plotY2, plotY1);  
      if (round(v % dataInterval) == 0) {
        if (v == dataMin) {
          textAlign(RIGHT);
        } else if (v == dataMax) {
          textAlign(RIGHT, TOP);
        } else {
          textAlign(RIGHT, CENTER);
        }
        text(v, plotX1 - 10, y);
        line(plotX1 - 4, y, plotX1, y);
      } else {
        line(plotX1 - 2, y, plotX1, y);
      }
    }
  }
}

void drawHorizontalLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);

  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);

  for (int row = 0; row < width; row++) {
    if (row % 100 == 0) {
      float x = map(row, 0, width, plotX1, plotX2);
      text(row, x, plotY2 + 10);
      line(x, plotY1, x, plotY2);
    }
  }
}

void drawEllipse(float x, float y) {
  noStroke();
  fill(col);
  ellipse(x, y, 4, 4);
}
