//Imports Processing's sound library
import processing.sound.*;

//Assigns the input audio to a variable
AudioIn mic;

//Assigns the amplitude of the primary sound wave to a variable
Amplitude analyzer;

//Used for the vertical movement of the player in relation to volume of the sound
float multiplier;

//Player classes/objects
//There are two players because there is a different player for each level even though
//they look the same
Player circle;
Player circle1;

//Line/step class
Lines[] branch = new Lines[50];

//Box class for the second level
Boxes[] Box = new Boxes[10];

//Declaration for the class and objects for all of the obstacles
Obstacles movingCircle;
Obstacles follow;
Obstacles spikes;
Obstacles shot;
Obstacles bullet;
Obstacles[] Cars = new Obstacles[8];
Obstacles fall;
Obstacles Boss;
Obstacles Turn;

//Buttons to help with the flow of the game
boolean button = true;
boolean button2 = true;
boolean button3 = true;
boolean button4 = true;

//Boolean variable to check if the player is alive or not
boolean alive = true;

//Font variable
PFont f;

//Time variables
int time = millis();
int time1 = millis();

void setup() {
  size(300, 800);

  f = createFont("Arial", 16, true);

  //Initialization of the player objects
  circle = new Player();
  circle1 = new Player();
  
  //Initialization of the obstacles
  movingCircle = new Obstacles(20, 100);
  follow = new Obstacles(0, 0);
  spikes = new Obstacles(0, height);
  shot = new Obstacles(int(random(width)), (2*height)/3);
  bullet = new Obstacles(shot.x, shot.y);
  fall = new Obstacles(int(random(width)), 0);
  Boss = new Obstacles(2.5, 75);
  Turn = new Obstacles(width/2, height/3);

  //Initialization of an object array 
  for (int l = 0; l < Cars.length; l++) {
    int rand = int(random(height));
    Cars[l] = new Obstacles(0, rand);
  }

  //Initialization of the lines/steps 
  for (int i = 0; i < branch.length; i++) {
    branch[i] = new Lines();
  }

  //Initialization of the boxes that will appear in level two
  int blah = 0;
  int wid = 10;
  for (int i = 0; i < Box.length; i++) {

    blah = blah + 80;
    wid = int(random(width - 10));

    Box[i] = new Boxes(0, blah, wid);
  }

  //Initialization of the audio variables
  mic = new AudioIn(this, 0);
  mic.start();

  analyzer = new Amplitude(this);
  analyzer.input(mic);
}

void draw() {
  background(255);

  //Assigns a variable to the volume of a sound
  multiplier = analyzer.analyze();

  //Gives the instructions before the game
  if (button4) {
    background(0, 0, 0);
    textFont(f, 15);
    fill(255);
    textAlign(CENTER);
    rectMode(CENTER);
    text("The objective of the game is to reach the top of the screen. To do this, press 'a' to move leftward, press 'd' to move rightward, and make noise to move upward. The louder the sound you make, the higher you will go. If no sound is made, the player (a small circle) will continue to move downwards. There will be steps in the first level that you can land on top of to help you move up. The first level will have obstacles that will try and eliminate the player. The second level will have long rectangles that the player also cannot touch and there will also be a purple player that will race against you. If the purple player reaches the bottom before you reach the top, you lose. Click the screen to begin", width/2, height/2, 300, 800);

    //Begins the game when the mouse is pressed on the screen
    if (mousePressed) {
      button4 = false;
    }
  } else {
    //Checks if the player is alive
    if (alive) {
      if (button2) {
        //Draws and keeps track of the player's movement
        circle.drawPlayer();
        circle.jumpPlayer();

        //Draws the lines for the player to use
        for (int i = 0; i < branch.length; i++) {
          branch[i].drawLines();
        }

        //Draws the obstacles and determines the illegal boundaries for the circle
        movingCircle.movingCircle();
        shot.shootingBox();
        fall.fallingStuff();
        Turn.rotatingCircle();
        follow.followingRect();

        //For the obstacle with the green square, there will be a long "laser" like line
        //that comes out of it and it will disappear every five seconds and reappear
        if (millis() > time + 1000) {
          bullet.bulletBox();

          if (millis() > time + 5000) {
            time = millis();
          }
        }

        //After fifteen seconds, a bunch of spikes will appear at the bottom, which forces
        // the player to move off of the bottom of the screen.
        if (millis() > time1 + 15000) {
          spikes.triBottom();
        }

        //These obstacles draw the little rightward moving rectangles
        for (int l = 0; l < Cars.length; l++) {
          int rand = int(random(5));
          Cars[l].drivingCars(rand);
        }

        //Helps with determining when the circle can land on top of a line
        land();

        //Determines when to change to level two
        level2();
      } else {
        //Checks to see if the player has won or not
        if (button3) {
          //Draws the player and keeps track of the player's movements for level 2
          levelChange();

          //Draws boxes that the player can't touch
          for (int i = 0; i < Box.length; i++) {
            Box[i].drawBoxes();
          }

          //Draws another rectangle coming out of the right side of the screen with
          //the space in between decreasing as the player moves higher up
          int change = 0;
          for (int i = 0; i < Box.length; i++) {
            change = change + 12;
            Box[i].drawOtherSide(change);
          }

          //The boss/rival/player that you want to beat
          Boss.theBoss();

          //Makes touching the rectangles illegal
          cantTouch();

          //Determines when the player wins
          toWin();
        } else {
          //Winner statement and allows the player to play again
          winner();
        }
      }
    } else {
      //Loser statement and allows the player to play again
      loser();
    }
  }
}

//Displays text and a red screen when the player loses
void loser() {
  background(255, 0, 0);
  textFont(f, 30);
  fill(0);
  textAlign(CENTER);
  rectMode(CENTER);
  text("Game Over! Click to play again", width/2, height/2, 300, 500);

  //Resets the level when the mouse is pressed
  if (mousePressed) {
    alive = true;
    circle.xPlayer = width/2;
    circle.yPlayer = 795;

    circle1.xPlayer = width/2;
    circle1.yPlayer = 795;

    time1 = millis();

    Boss.x = 2.5;
    Boss.y = 75;
    Boss.s = 0;
    
    follow.x = 0;
    follow.y = 0;
  }
}

//If the player has made it to the top of the second level, the player has won
void toWin() {
  if (circle1.yPlayer == 2.5) {
    button3 = false;
  }
}

//Helps with the player landing on top of the lines/steps
void land() {
  int i = 0;
  while (i < 50) {
    if ((circle.xPlayer - 2.5 >= branch[i].x1Lines) 
      && (circle.xPlayer + 2.5 <= branch[i].x2Lines) 
      && (circle.yPlayer + 2.5 == branch[i].yLines + 1)) {

      circle.yPlayer = branch[i].yLines - 2.5;

      button = false;
    }
    if ((circle.xPlayer - 2.5 > branch[i].x2Lines) || (circle.xPlayer + 2.5 < branch[i].x1Lines)) {
      button = true;
    }

    i++;
  }
}

//Winner statement for when the player wins the second level
void winner() {
  background(0, 255, 0);
  textFont(f, 30);
  fill(0);
  textAlign(CENTER);
  rectMode(CENTER);
  text("Congratulations! You Win! Click to Start Over!", width/2, height/2, 300, 500);

  //Allows the player to start over from the first level if the mouse is pressed
  if (mousePressed) {
    button2 = true;
  }
}

//Changes to level two if the player reaches the top of the first level
void level2() {
  if (circle.yPlayer == 2.5) {
    button2 = false;
  }
}

//Draws and tracks the movement of the player that will appear in the second level
void levelChange() {
  circle1.drawPlayer();
  circle1.jumpPlayer();
}

//Determines the illegal zones for the corresponding rectangles in level 2 and if the
//player touches one of these zones, they lose
void cantTouch() {
  for (int i = 0; i < Box.length; i++) {
    if ((circle1.xPlayer > 0) && (circle1.xPlayer - 2.5 < Box[i].w)
      && (circle1.yPlayer + 2.5 > Box[i].y) && (circle1.yPlayer - 2.5 < (Box[i].y + 30))) {
      alive = false;
    }

    if ((circle1.xPlayer + 2.5 > Box[i].w + (i*12 + 12)) && (circle1.xPlayer < width)
      && (circle1.yPlayer + 2.5 > Box[i].y) && (circle1.yPlayer - 2.5 < (Box[i].y + 30))) {
      alive = false;
    }
  }
}
