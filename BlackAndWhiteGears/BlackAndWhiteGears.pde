//Size configurations
float SmallGears       = 25;  //number of small gears
float BigGears         = 16;  //number of big gears
float SmallGearRadius  = 48;  //diameter of the small gear (yes, really. The diameter)
float BigGearRadius    = 64;  //diameter of the big gear
float FirstX           = 100; //X offset from the screen border
float FirstY           = 100; //Y offset from the screen border
float BorderDistance   = 10;  //Distance from the border of the table to the border of the gear
float BorderRadius     = 40;  //Roundness of the table

//Color configurations (all shades of gray)
int BackGroundColor    = 140;
int TableTopColor      = 30;
int TeethColor         = 60;  //keep the same as GearColor2
int GearColor1         = 255;
int GearColor2         = 60;  //keep the same as TeethColor
int GearDotColor       = 50;

//Options. Change however you want
Boolean HasTeeth       = true;
Boolean HasGearDot     = true;
Boolean HasTable       = true;

//System variables. Don't mess with these
float StartX = FirstX - (SmallGearRadius/2) - BorderDistance;
float StartY = FirstY - (SmallGearRadius/2) - BorderDistance;
float EndX = ((SmallGears-1)%int(sqrt(SmallGears))*(SmallGearRadius+BigGearRadius)/2*sqrt(2)) + FirstX + (SmallGearRadius/2) + BorderDistance;
float EndY = ((SmallGears/int(sqrt(SmallGears))-1)*(SmallGearRadius+BigGearRadius)/2*sqrt(2)) + FirstY + (SmallGearRadius/2) + BorderDistance;
Boolean followsMouse = false;
int gearIndex = -1;
float baseAngle = 0;
float angleDiff = 0;
PVector MousePos = new PVector();

class Gear {
  float RotSpeed;
  PVector Pos;
  float Angle;
  float Diameter;
  int Direction;
  float teethSide;

  Gear(PVector pos, float ang, float dia, int dir) {
    this.Pos       = pos;
    this.Angle     = ang;
    this.Diameter  = dia;
    this.Direction = dir;
    this.RotSpeed  = 0.01;
    this.teethSide = 5.7; //this is actually a magic number that makes the teeth match given the gears sizes.
  }

  void draw() {
    //If it has teeth, draw them
    if(HasTeeth)
      drawTeeth();
    
    pushMatrix();

    //Move to position
    translate(this.Pos.x, this.Pos.y);
    
    //Rotate
    rotate(this.Angle);
    noStroke();
    fill(GearColor1);
    
    //Draw first half-circle
    if(HasTeeth)
      arc(0, 0, this.Diameter-this.teethSide, this.Diameter-this.teethSide, 0, PI, OPEN);
    else
      arc(0, 0, this.Diameter, this.Diameter, 0, PI, OPEN);
      
    //Draw second half-circle
    fill(GearColor2);
    if(HasTeeth)
      arc(0, 0, this.Diameter-this.teethSide, this.Diameter-this.teethSide, PI, TWO_PI, OPEN);
    else
      arc(0, 0, this.Diameter, this.Diameter, PI, TWO_PI, OPEN);
      
    //Draw the middle dot
    if(HasGearDot){
      fill(GearDotColor);
      ellipse(0, 0, 5, 5);
    }
    //Restaura matrix
    popMatrix();
    
  }
  //Draws the teeth if the gears have some
  void drawTeeth() {
    pushMatrix();
    fill(TeethColor);
    noStroke();
    rectMode(CENTER);
    
    //Go to position
    translate(this.Pos.x, this.Pos.y);
    
    //Rotate to the right angle
    rotate(this.Angle);

    //Find out the right number of squares
    int NoS = int((PI*this.Diameter)/(this.teethSide*2))-1;
    
    //Creates one square in the right position, rotate for the next position and repeat for each square
    for (int i = 0; i < NoS; i++) {
      rotate(TWO_PI/NoS);
      rect(0, -(this.Diameter/2)+1, this.teethSide, this.teethSide);
    }
    popMatrix();
  }
  
  void update() {
    
    this.Angle = this.Direction*(baseAngle+angleDiff)/this.Diameter*60;
    
    if (this.Angle >= TWO_PI)
      this.Angle -= TWO_PI;
    if (this.Angle <= -TWO_PI)
      this.Angle += TWO_PI;
  }
}

ArrayList<Gear> gears;

void setup() {
  frameRate(60);
  size(525, 525);
  float x, y;
  gears = new ArrayList<Gear>();

  //Create the gears
  for (int i = 0; i < SmallGears; i++) {
    //First the small ones
    x = float(i%int(sqrt(SmallGears))) * (SmallGearRadius + BigGearRadius)/2 * sqrt(2) + FirstX;
    y = float(i/int(sqrt(SmallGears))) * (SmallGearRadius + BigGearRadius)/2 * sqrt(2) + FirstY;
    gears.add(new Gear(new PVector(x, y), 0, SmallGearRadius, 1));
  }
  for (int i = 0; i < BigGears; i++) {
    //Then, the big ones
    x = float(i%int(sqrt(BigGears))) * (SmallGearRadius + BigGearRadius)/2 * sqrt(2) + (SmallGearRadius + BigGearRadius)/4 * sqrt(2) + FirstX;
    y = float(i/int(sqrt(BigGears))) * (SmallGearRadius + BigGearRadius)/2 * sqrt(2) + (SmallGearRadius + BigGearRadius)/4 * sqrt(2) + FirstY;
    gears.add(new Gear(new PVector(x, y), 0, BigGearRadius, -1));
  }
}
void draw() {
  background(BackGroundColor);
  
  //Draws the table
  if(HasTable){
    fill(TableTopColor);
    noStroke();
    rectMode(CORNERS);
    rect(StartX, StartY, EndX, EndY, BorderRadius, BorderRadius, BorderRadius, BorderRadius);
  }
  if(followsMouse){
    angleDiff = angleBetween(gears.get(gearIndex).Pos.x, gears.get(gearIndex).Pos.y, MousePos.x, MousePos.y, gears.get(gearIndex).Pos.x, gears.get(gearIndex).Pos.y, mouseX, mouseY);
  }
  //Draws each gear
  for (int i = 0; i < gears.size(); i++) {
    //Updates the rotation angle
    gears.get(i).update();
    
    //Draws on screen
    gears.get(i).draw();
  }
  //saveFrame("gears-######.png");
  //if(frameCount >= 840)
    //exit();
  
}
float angleBetween(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4){
  PVector p1 = new PVector(x2-x1, y2-y1);
  PVector p2 = new PVector(x4-x3, y4-y3);
  return PVector.angleBetween(p1,p2);
}
void mousePressed(){
  //HasTeeth = !HasTeeth;
  followsMouse = true;
  print("pof\n");
  int index = 0;
  float minDist = 99999;
  float currDist;
  MousePos.x = mouseX;
  MousePos.y = mouseY;
  for (int i = 0; i < gears.size(); i++) {
    currDist = dist(gears.get(i).Pos.x, gears.get(i).Pos.y, mouseX, mouseY);
    if(currDist <= minDist){
      index = i;
      minDist = currDist;
    }
  }
  gearIndex = index;
}
void mouseReleased(){
  followsMouse = false;
  baseAngle += angleDiff;
  angleDiff = 0;
}