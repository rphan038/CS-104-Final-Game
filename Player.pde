//Player class
class Player {
  //Instance variables
  float xPlayer;
  float yPlayer;
  
  //Constructors
  Player() {
    xPlayer = width/2;
    yPlayer = 795;
  }
  
  //Draws the player
  void drawPlayer() {
    fill(255, 0, 0);
    stroke(255, 0, 0);
    ellipseMode(CENTER);
    ellipse(xPlayer, yPlayer, 5, 5);
  }
  
  //Tracks the movement of the player
  void jumpPlayer() {
    //Relates the vertical movement of the player to volume of the sound
    yPlayer = yPlayer - (int(10 * multiplier));
    yPlayer = constrain(yPlayer, 0, height - 5);
    
    //If the player is on top of a line, the player will not continue to fall down
    //If the player is not on top of a line, the player will continue to fall down
    if(button) {
      yPlayer = yPlayer + 0.5;
    }
    
    //If 'a' is pressed, the player will move leftwards and if 'd' is pressed, the player
    //will move rightwards
    if(keyPressed && key == 'a') {
      xPlayer = xPlayer - 1;
      xPlayer = constrain(xPlayer, 2.5, width - 2.5);
    } else if(keyPressed && key == 'd') {
      xPlayer = xPlayer + 1;
      xPlayer = constrain(xPlayer, 2.5, width - 2.5);
    }
  }
}
