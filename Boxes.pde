class Boxes {
  //Instance Variables
  int x;  //x location of the box
  int y;  //y location of the box
  int w;  //width of the box
  int h;  //height of the box
  
  //Constructor
  Boxes(int _x, int _y, int _w) {
    x = _x;
    y = _y;
    w = _w;
    h = 30;
  }
  
  //Draws the boxes
  void drawBoxes() {
    fill(0);
    stroke(0);
    rectMode(CORNER);
    rect(x, y, w, h);
  }
  
  //Draws a rectangle coming out of the right side of the screen with the space between
  //them decreasing the higher up you go. The parameter helps with determing how narrow
  //the space is.
  void drawOtherSide(int narrow) {
    fill(0);
    stroke(0);
    rectMode(CORNER);
    rect(x + w + narrow, y, width - (x + w + narrow), h);
  }
}
