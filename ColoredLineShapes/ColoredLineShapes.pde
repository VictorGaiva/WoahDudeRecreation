int NumberOfShapes = 13;
float SpeedMultiplier = 0.15;
class LineShape {
  PVector Pos;
  float Radius;
  int LineCount;
  color LineColor;
  float DotAngle;
  float DotSpeed;
  ArrayList<PVector> Edges;
  LineShape(float _posX, float _posY, float _rad, int _count, color _col) {
    float x, y;
    this.Pos = new PVector(_posX, _posY);
    this.DotAngle = 0;
    this.Radius = _rad;
    this.LineCount = _count;
    this.LineColor = _col;
    //The speed is which that each dots makes a run around the circle a number of times based on what line it is on
    this.DotSpeed = (float(NumberOfShapes) + 4 - float(this.LineCount))*SpeedMultiplier;
    
    //Calculate the edges already for later use
    this.Edges = new ArrayList<PVector>();
    //Create each vertex of the colored outline
    for (int i = 0; i < this.LineCount; i++) {
      x = this.Radius * cos((TWO_PI/this.LineCount)*i);
      y = this.Radius * sin((TWO_PI/this.LineCount)*i);
      this.Edges.add(new PVector(x, y));
    }
    
  }

  void draw() {
    PVector Edge;
    float DotX, DotY;
    
    float X1, Y1;
    float X2, Y2;
    float X3, Y3;
    float X4, Y4;
    int AuxCalc0;
    float AuxCalc1, AuxCalc2, AuxCalc3;
    
    pushMatrix();
    noFill();
    translate(this.Pos.x, this.Pos.y);
    stroke(this.LineColor);
    strokeWeight(2);
    
    //Rotate so that the bottom lines match the same angle
    rotate((TWO_PI/360)*(((this.LineCount-2)*180)/this.LineCount)/2);
    //rotate(this.DotAngle);
    
    //Crate colored outline
    beginShape();
    //Create each vertex of the colored outline
    for (int i = 0; i < this.Edges.size(); i++) {
      Edge = this.Edges.get(i);
      vertex(Edge.x, Edge.y);
    }
    endShape(CLOSE);
    
    //Create black dot at the right position
    fill(0);
    stroke(0);
    
    //Dot position at 'circle'
    X1 = this.Radius * cos(this.DotAngle);
    Y1 = this.Radius * sin(this.DotAngle);
    
    //Center of 'circle'
    X2 = 0;
    Y2 = 0;

    //We use this value a lot so let's calculate them already
    AuxCalc0 = floor(this.DotAngle/(TWO_PI/this.LineCount));
    
    //Find the points where the lines touch the circle
    //Here
    X3 = this.Edges.get(AuxCalc0%LineCount).x;
    Y3 = this.Edges.get(AuxCalc0%LineCount).y;
    //and here
    X4 = this.Edges.get((AuxCalc0+1)%LineCount).x;
    Y4 = this.Edges.get((AuxCalc0+1)%LineCount).y;

    //Some pre calculations
    AuxCalc1 = (X1*Y2 - Y1*X2);
    AuxCalc2 = (X3*Y4 - Y3*X4);
    AuxCalc3 = (X1 - X2)*(Y3 - Y4)-(Y1 - Y2)*(X3 - X4);
    
    //Given two lines, which described by two different points, find where they intersect
    DotX = ((AuxCalc1*(X3 - X4)-(X1 - X2)*AuxCalc2)/AuxCalc3);
    DotY = ((AuxCalc1*(Y3 - Y4)-(Y1 - Y2)*AuxCalc2)/AuxCalc3);
    
    //Draw a dot where these lines intersect
    ellipse(DotX, DotY, 8, 8);
    
    //Line
    //strokeWeight(2);
    //stroke(0, 0, 0, 80);
    //line(0 , 0, 250*cos(this.DotAngle), 250*sin(this.DotAngle));
    
    popMatrix();
  }
  void update(){
    //Update angle
    //if(this.LineCount == 13 && this.DotAngle >= TWO_PI*4)
    //  exit();
    this.DotAngle += (TWO_PI/360)*this.DotSpeed;
    //Make sure the angles are within the limit (unecessary?)
    //if (this.DotAngle >= TWO_PI){
    //  this.DotAngle -= TWO_PI;
    //}
    //if (this.DotAngle <= -TWO_PI){
    //  this.DotAngle += TWO_PI;
    //}
  }
}
ArrayList<LineShape> var;

void setup() {
  size(600, 600);
  background(230);
  //Change the color mode to set the colors of the outlines
  colorMode(HSB, NumberOfShapes, NumberOfShapes, NumberOfShapes);
  var = new ArrayList<LineShape>();
  for (int i = 0; i < NumberOfShapes; i++) {
    var.add(new LineShape(width/2, height/2, 50+i*15, 3+i, color(i, NumberOfShapes*0.6, NumberOfShapes)));
  }
  //Restore the color mode
  colorMode(RGB, 255, 255, 255);
}

void draw() {
  background(230);
  //draw each dot
  for (int i = 0; i < var.size(); i++) {
    var.get(i).draw();
    //if(mousePressed)
      var.get(i).update();
  }
  //saveFrame("colored-lines-########.png");
}