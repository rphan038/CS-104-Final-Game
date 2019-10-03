class Lines extends Player {
  //Instance variables
  int x1Lines;
  int x2Lines;
  int yLines;
  
  //Constructors
  Lines() {
    x1Lines = int(random(width));
    x2Lines = x1Lines + 15;
    yLines = int(random(height));
  }
  
  //Draws the lines/steps
  void drawLines() {
    stroke(0);
    line(x1Lines, yLines, x2Lines, yLines);
  }
}
  
