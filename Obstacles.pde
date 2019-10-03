class Obstacles {
  //Instance variables
  float x; //x location of the obstacle
  float y; //y location of the obstacle
  float diam;  //Diameter of the obstacle if the obstacle is circular
  int w;  //Width of the obstacle
  int h;  //Height of the obstacle
  float speed;  //Direction and speed of the obstacle
  float gravity; //Acceleration of obstacle
  int s; //An integer
  float theta; //Angle for rotating obstacle

  //Constructor
  Obstacles(float _x, float _y) {
    x = _x;
    y = _y;
    diam = 50;
    w = 20;
    h = 20;
    speed = 1;
    gravity = 0.1;
    s = 0;
    theta = 0;
  }

  //This obstacle moves left and right infinitely
  void movingCircle() {
    fill(209);
    noStroke();
    ellipse(x, y, diam, diam);

    x = x + (1 * speed);

    //Changes the direction of the circle when it has reached one of the edges
    if (x > width || x < 0) {
      speed = speed * (-1);
    }

    //Determines the distance between the player and the circle to check if it is touching
    float distance = dist(circle.xPlayer + 2.5, circle.yPlayer + 2.5, x, y);

    if (distance < diam/2) {
      alive = false;
    }
  }

  //This obstacle is a blue rectangle that starts at (0,0) and follows the player and 
  //will eventually hit the player if the player stops moving
  void followingRect() {
    float dx = circle.xPlayer - x;
    float dy = circle.yPlayer - y;
    if(frameCount % 60 == 0) {
      
      
      x += 0.5*dx;
      y += 0.5*dy;
    } else {
      x += 0.005*dx;
      y += 0.005*dy;
    }
      
    fill(0, 0, 255, 127);
    noStroke();
    rect(x, y, 10, 5);
    
    if(circle.xPlayer > x && circle.xPlayer < x + 10 
    && circle.yPlayer > y && circle.yPlayer < y + 5) {
      alive = false;
    }
  }

  //These are the spikes on the bottom that appear after 15 seconds
  void triBottom() {
    int i = 0;
    while (i < 30) {
      fill(209);
      noStroke();
      triangle(x + (10 * i), y, x + 5 + (10 * i), y - 10, x + 10 + (10 * i), y);
      i++;
    }

    if (circle.yPlayer > height - 10) {
      alive = false;
    }
  }

  //The green box that moves left and right
  void shootingBox() {
    fill(209);
    noStroke();
    rect(x, y, diam/3, diam/3);

    x = x + (1 * speed);

    if (x > width - diam/3 || x < 0) {
      speed = speed * (-1);
    }

    if ((circle.xPlayer + 2.5 > x) && (circle.xPlayer - 2.5 < x + diam/3) 
      && (circle.yPlayer + 2.5 > y) && (circle.yPlayer - 2.5 < y + diam/3)) {
      alive = false;
    }
  }

  //The long "laser" that shoots out of the green box
  void bulletBox() {
    fill(0);
    stroke(0);
    rectMode(CORNER);
    rect(shot.x + diam/6, shot.y + diam/6, 1, height - shot.y + diam/3);

    if ((circle.xPlayer + 2.5 > shot.x + diam/6) && (circle.xPlayer - 2.5 < shot.x + diam/6 + 1)
      && (circle.yPlayer + 2.5 > shot.y + diam/6)) {
      alive = false;
    }
  }

  //The little rectangles that move rightwards from the left of the screen at different speeds
  void drivingCars(int howFast) {
    fill(209);
    stroke(0);
    rectMode(CORNER);
    rect(x, y, 10, 5);

    //Moves at random speeds
    x = x + howFast;

    //Repositions the car at a different location after the car has left the screen
    if (x > width) {
      x = 0;
      y = random(height);
    }

    //Makes touching the cars illegal
    if ((circle.xPlayer + 2.5 > x) && (circle.xPlayer - 2.5 < x + 10) 
      && (circle.yPlayer + 2.5 > y) && (circle.yPlayer - 2.5 < y + 5)) {
      alive = false;
    }
  }

  //A falling rectangle that accelerates
  void fallingStuff() {
    fill(209);
    noStroke();
    rectMode(CENTER);
    rect(x, y, 20, 15);

    //Increases the speed and accelerates the obstacle
    y = y + speed;
    speed = speed + gravity;

    //When the obstacle has moved off the screen, it falls from a different x location
    if (y > height) {
      x = int(random(width));
      y = 0;
      speed = 1;
    }

    //Makes it so that you can't touch the falling rectangle
    if ((circle.xPlayer + 2.5 > x - 10) && (circle.xPlayer - 2.5 < x + 10)
      && (circle.yPlayer + 2.5 > y - 15/2) && (circle.yPlayer - 2.5 < y + 15/2)) {
      alive = false;
    }
  }

  //The small boss/rival that tries to reach the bottom before you reach the top
  void theBoss() {
    fill(255, 0, 255);
    noStroke();
    ellipseMode(CENTER);
    ellipse(x, y, 10, 10);

    //Determines the movement of the rival player
    if (x - 5 < Box[s].w && y <= Box[s].y) {
      x = x + 1;
      y = Box[s].y - 5;
    } else if (x > Box[s].w + (s*12 + 12) - 5 && y <= Box[s].y) {
      x = x - 1;
      y = Box[s].y - 5;
    } else if (x > Box[s].w && x < Box[s].w + (s*12 + 12)) {
      y = y + 1;

      if (y == Box[s + 1].y) {
        s = s + 1;
        s = constrain(s, 0, 9);
      }
    }
    
    //Makes the player lose when the rival has reached the bottom
    if(y == height) {
      alive = false;
      x = 2.5;
      y = 75;
      s = 0;
    }
  }
  
  //A circle that moves in a circular motion
  void rotatingCircle() {
    fill(209);
    stroke(0);
    ellipseMode(CENTER);
    ellipse(x, y, 30, 30);
    
    //Movement of the circle
    x = x + 20*cos(theta);
    y = y + 20*sin(theta);
    
    theta = theta + PI/12;
    
    //Finds the distance between the player and the circle to see whether the player
    //is touching the circle or not
    float distance = dist(circle.xPlayer + 2.5, circle.yPlayer + 2.5, x, y);

    if (distance < 15) {
      alive = false;
    }
  }
}
