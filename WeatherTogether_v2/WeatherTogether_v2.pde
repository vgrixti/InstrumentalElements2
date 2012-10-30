import processing.serial.*;
import cc.arduino.*;


//import sound libraries  
import ddf.minim.*;
import ddf.minim.analysis.*;

//set up minim player
Minim minim;

//create five variables for each xylophone bar
AudioPlayer xylNote1;
AudioPlayer xylNote2;
AudioPlayer xylNote3;
AudioPlayer xylNote4;
AudioPlayer xylNote5;
//create four variables for each song file
AudioPlayer windSong;
//rain
int rain1 = 0;
int rain2 = 0;
int rain3 = 0;

Arduino arduino;

int BUFFER_START = 10;

//create five variables for reading each analog xylophone pin
int xyl1 = 0;
int xyl2 = 0;
int xyl3 = 0;
int xyl4 = 0;
int xyl5 = 0;

int xyl1Check = 0;
int xyl2Check = 0;
int xyl3Check = 0;
int xyl4Check = 0;
int xyl5Check = 0;

int orangePress = 0;
int yellowPress = 0;
int bluePress = 0;
int pinkPress = 0;
int redPress = 0;

int orangeBuffer = 0;
int yellowBuffer = 0;
int redBuffer = 0;
int pinkBuffer = 0;
int blueBuffer = 0;

Sun[] oranges = new Sun[10];
Sun[] yellows = new Sun[10];
Sun[] blues = new Sun[10];
Sun[] pinks = new Sun[10];
Sun[] reds = new Sun[10];
int curO = 0;
int curY = 0;
int curB = 0;
int curP = 0;
int curR = 0;

//sun/rain variables
//test combo1
int combo1 = 0;
int combo1_delay = 0;
int colourDelay = 0;

//for coloured rain with sun
int xylrainR = 255;
int xylrainG = 255;
int xylrainB = 255;

//create variable for reading wind pin
int windVal = 0;

int numStringyThingys = 5;
StringyThingy[] stringyThingys = new StringyThingy[numStringyThingys];
float gravity = 0.5;
float mass = 1.0;
int numPoints = 4;
Point[] points = new Point[numPoints];
boolean accordionTrigger = false;

//rain
int numParticles = 150;
GenParticle[] p = new GenParticle[numParticles];




void setup() {
  size(900, 900);
  smooth();
  fill(0);
  noStroke();
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  //wind
  for (int i = 0; i < numStringyThingys; i++) {   
    //set inital starting point for each wind string
    Point startingPoint = new Point(width, height);
    stringyThingys[i] = new StringyThingy(startingPoint);
  }

  arduino.pinMode(5, arduino.INPUT); //set up analog 0 input

  //sun
  arduino.pinMode(13, arduino.INPUT); //set up digital 13 input
  arduino.pinMode(12, arduino.INPUT); //set up digital 12 input
  arduino.pinMode(11, arduino.INPUT); //set up digital 11 input
  arduino.pinMode(10, arduino.INPUT); //set up digital 10 input
  arduino.pinMode(9, arduino.INPUT); //set up digital 9 input


  minim = new Minim(this); 
  //load track
  //load xyl loop files
  xylNote1 = minim.loadFile("note1.wav", 2048);
  xylNote2 = minim.loadFile("note2.wav", 2048);
  xylNote3 = minim.loadFile("note3.wav", 2048);
  xylNote4 = minim.loadFile("note4.wav", 2048);
  xylNote5 = minim.loadFile("note5.wav", 2048);
  //load wind loop files
  windSong = minim.loadFile("wind1.aif", 2048);


  //rain

  for (int i = 0; i < p.length; i++) {
    float velX = random(-1, 1);
    float velY = -random(0, 10);
    // Inputs: x, y, x-velocity, y-velocity,
    // radius, origin x, origin y
    int startX = (width / numParticles) * i+1;
    p[i] = new GenParticle(startX, -50, velX, velY, 1, 255, 255, 255, startX, -50);
  }
}

void draw() {
  background(214, 226, 237, 20);

  //sun draw!

  for (int i = 0; i < 10; i++) {
    if (oranges[i] != null) {
      oranges[i].update();
      oranges[i].display();
    }
    if (yellows[i] != null) {
      yellows[i].update();
      yellows[i].display();
    } 
    if (blues[i] != null) {
      blues[i].update();
      blues[i].display();
    }
    if (pinks[i] != null) {
      pinks[i].update();
      pinks[i].display();
    }
    if (reds[i] != null) {
      reds[i].update();
      reds[i].display();
    }
  }

  //assign pins to variables
  xyl1 = arduino.digitalRead(13);
  xyl2 = arduino.digitalRead(12);
  xyl3 = arduino.digitalRead(11);
  xyl4 = arduino.digitalRead(10);
  xyl5 = arduino.digitalRead(9);
  println(xyl1);
  println(xyl2);
  println(xyl3);
  println(xyl4);
  println(xyl5);
  
  // if rain and sun are playing together! give a short delay so that the colour burst is noticable. 
  if (colourDelay + 1000 > millis()) {
    for (int i = 0; i < p.length; i++) {
      p[i].colour_change(xylrainR, xylrainG, xylrainB);
    }
  } else {
    for (int i = 0; i < p.length; i++) {
      p[i].colour_change(255, 255, 255);
    }
  }

  //orange sun
  if (xyl1 == 1 && xyl1Check == 0 && millis() - orangePress > 0 && orangeBuffer == 0) {
    xyl1Check = 1;
    
    orangePress = millis();
    
    colourDelay = millis();
    
    xylrainR = 242;
    xylrainG = 175;
    xylrainB = 2;
    
    oranges[curB] = new Sun(color(242, 175, 2, 40));    
    curO += 1;
    if (curO == 10) {
      curO = 0;
    }
    xylNote1.play(0);
    orangeBuffer = BUFFER_START;
  }
  if (orangeBuffer > 0) {
    orangeBuffer--;
  }

  if (xyl1 == 0) xyl1Check = 0;

  //yellow sun
  if (xyl2 == 1 && xyl2Check == 0 && millis() - yellowPress > 0 && yellowBuffer == 0) {
    xyl2Check = 1;
    combo1 = 1;
    combo1_delay = millis();

    yellowPress = millis();
    
    colourDelay = millis();

    xylrainR = 235;
    xylrainG = 231;
    xylrainB = 13; 

    yellows[curR] = new Sun(color(235, 231, 13, 40));
    curY += 1;
    if (curY == 10) {
      curY = 0;
    }
    xylNote2.play(0);
    yellowBuffer = BUFFER_START;
  }
  if (yellowBuffer > 0) {
    yellowBuffer--;
  }

  if (xyl2 == 0) xyl2Check = 0;

  //blue sun
  if (xyl3 == 1 && xyl3Check == 0 && millis() - bluePress > 0 && blueBuffer == 0) {
    xyl3Check = 1;

    bluePress = millis();   
   
    colourDelay = millis();

    xylrainR = 90;
    xylrainG = 166;
    xylrainB = 219;  

    blues[curR] = new Sun(color(90, 166, 219, 40));
    curB += 1;
    if (curB == 10) {
      curB = 0;
    }

    xylNote3.play(0);
    blueBuffer = BUFFER_START;
  }
  if (blueBuffer > 0) {
    blueBuffer--;
  }

  if (xyl3 == 0) xyl3Check = 0;

  //purple/pink sun
  if (xyl4 == 1 && xyl4Check == 0 && millis() - pinkPress > 0 && pinkBuffer == 0) {
    xyl4Check = 1;

    pinkPress = millis();

    colourDelay = millis();

    xylrainR = 199;
    xylrainG = 89;
    xylrainB = 151;     

    pinks[curR] = new Sun(color(199, 89, 151, 40));
    curP += 1;
    if (curP == 10) {
      curP = 0;
    }
    xylNote4.play(0);

    pinkBuffer = BUFFER_START;
  }
  if (pinkBuffer > 0) {
    pinkBuffer--;
  }

  if (xyl4 == 0) xyl4Check = 0;


  //purple sun
  if (xyl5 == 1 && xyl5Check == 0 && millis() - redPress > 0 && redBuffer == 0) {
    xyl5Check = 1;

    redPress = millis(); 
 
    colourDelay = millis();

    xylrainR = 255;
    xylrainG = 72;
    xylrainB = 0;   

    reds[curR] = new Sun(color(255, 72, 0, 40));
    curR += 1;
    if (curR == 10) {
      curR = 0;
    }
    xylNote5.play(0);


    redBuffer = BUFFER_START;
  }
  if (redBuffer > 0) {
    redBuffer--;
  }

  if (xyl5 == 0) xyl5Check = 0;



  //wind draw!

  windVal = arduino.analogRead(5);
  if (windVal > 900) { 
    println(windVal);
    arduino.digitalWrite(13, Arduino.HIGH);
    accordionTrigger=true;
    windSong.play(0);
  }
  //loop through wing strings and move to a new random point every time accordion trigger is set to true
  for (int i= 0; i < numStringyThingys; i++) {
    //if the user has triggered the accordion
    if (accordionTrigger==true) {

      //GENERATE A NEW POINT
      //tell the wind string about it 
      int randomX = (int) random(0, width);
      int randomY = (int) random(0, height);
      //set newPoint to randomX randomY
      Point newPoint = new Point (randomX, randomY);
      //call stringieThingys and set them to the current point which is newpoint
      stringyThingys[i].setCurrentPoint(newPoint);
    }

    // Point currentPoint = points[stringyThingys[i].nextPoint];
    stringyThingys[i].DrawAtPoint();
  }
  //set accordionTrigger to false after the loop has ended
  accordionTrigger=false;



  //rain draw!
  rain1 = arduino.analogRead(0);
  rain2 = arduino.analogRead(1);
  rain3 = arduino.analogRead(2);

  //println(rain1 + "+" + rain2 + "+" + rain3);


  fill(214, 226, 237, 20);
  rect(0, 0, width, height);
  fill(255, 150);
  for (int i = 0; i < p.length; i++) {

    p[i].update();
    p[i].reset_vy();
    p[i].display();
  }
  if (rain1 <= 5 || rain2 <= 5 || rain3 <= 5 ) {

    arduino.digitalWrite(13, Arduino.HIGH);
    //   numParticles = 50;
    // GenParticle[] p = new GenParticle[numParticles];
    //    for (int i = 0; i < p.length; i++) {
    //      float velX = random(-1, 1);
    //      float velY = -i;
    //      // Inputs: x, y, x-velocity, y-velocity,
    //      // radius, origin x, origin y
    //      int startX = (width / numParticles) * i+1;
    //      p[i] = new GenParticle(startX, -50, velX, velY, 
    //      9.0, startX, -50);
    //    }  
    for (int i = 0; i < p.length; i++) {
      p[i].flagreset();
      p[i].update();
      p[i].regenerate();
      p[i].display();
    }
  } 
  else {
    arduino.digitalWrite(13, Arduino.LOW);
  }
}



