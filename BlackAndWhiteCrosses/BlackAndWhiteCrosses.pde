float SquareSize    = 30; //<>//
class Cross {
  PVector   Pos;
  float     Angle;
  int       Color;
  Cross(float _posX, float _posY, int _color) {
    this.Pos = new PVector();
    this.Pos.x = _posX;
    this.Pos.y = _posY;
    this.Color = _color;
    this.Angle = 0;
  }

  void draw() {
    pushMatrix();
    //Setup
    fill(this.Color);
    noStroke();
    translate(this.Pos.x, this.Pos.y);
    rotate(this.Angle);
    rectMode(CENTER);

    //Draw rect1
    rect(0, 0, SquareSize, SquareSize*3);

    //Draw rect2
    rect(0, 0, SquareSize*3, SquareSize);
    popMatrix();
  }

  void turn(float _angle) {
    this.Angle += _angle;

    if (this.Angle >= TWO_PI)
      this.Angle -= TWO_PI;
    if (this.Angle <= -TWO_PI)
      this.Angle += TWO_PI;
  }

  void update() {
  }
}
ArrayList<Cross> Crosses;
void setup() {
  size(600, 600);
  background(150);
  float X;
  float Y;
  float lastY = -1;
  int NumberOfRols = int(width/SquareSize);
  int NumberOfCols = int(height/SquareSize);
  int NumberOfSquares = NumberOfRols*NumberOfCols;
  Boolean aux = true;
  Crosses = new ArrayList<Cross>();
  //White
  for (int i = 0; i < NumberOfSquares; i += 1) {
    Y = i/NumberOfRols;
    X = i%NumberOfCols;
    if (lastY != Y) {
      if ((X/5)%2 == 1)
        aux = false;
      else
        aux = true;
    }
    if (X%5 == (3*Y)%5) {
      if (aux)
        Crosses.add(new Cross(X*SquareSize +SquareSize/2, Y*SquareSize +SquareSize/2, 230));
      else
        Crosses.add(new Cross(X*SquareSize +SquareSize/2, Y*SquareSize +SquareSize/2, 80));
      aux = !aux;
    }
    lastY = Y;
  }
  //Black
  //for (int i = 0; i < NumberOfSquares; i += 1) {
  //  Y = i/NumberOfCols;
  //  X = i%NumberOfRols;
  //  Crosses.add(new Cross(X*SquareSize +SquareSize/2, Y*SquareSize +SquareSize/2, 80));
  //}
  frameRate(1);
}
int j = 0;
void draw() {
  //background(150);

  if (j > Crosses.size()-1)
    j = 0;
  //Crosses
  //for(int i = 0; i < Crosses.size(); i++){
  print();
  Crosses.get(j).draw();
  //}
  if (j > Crosses.size()-1)
    j = 0;

  stroke(255);
  //vertical
  for (int i = 0; i < width; i +=SquareSize) {
    line(i, 0, i, height);
  }
  //horizontal
  for (int i = 0; i < height; i +=SquareSize) {
    line(0, i, width, i);
  }
  j++;
}
void mouseClicked() {
  //j++;
}