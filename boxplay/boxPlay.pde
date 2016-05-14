 //<>// //<>//

int edgeSize = 100;
Box bx,bx2,bx3;
Point center;
void setup() {
  background(0);
  size(800,800,P3D);
  stroke(0);
  strokeWeight(1);
  center = new Point(400,400,200);
  bx = new Box(center, 300,300,100);  
  bx2 = new Box(center, 150,150,50);
  bx3 = new Box(center, 50,50,25);
  //bx.setInitAngle(5);
  //bx2.setInitAngle(125);
  //bx3.setInitAngle(60);
  
}


void draw() {
  //background(255);
  //rotate(5);
  bx3.show();
  bx.show();
  bx2.show();
  
  //noLoop();
}

class Point {
  public float x;
  public float y;
  public float z;
  
  public Point(float _x, float _y, float _z) {
    x = _x; y=_y; z=_z;
  }
  
  public Point(float _x, float _y) {
    x = _x; y = _y; z = 0;
  }
  
  public Point(Point pt) {
    x = pt.x; y = pt.y; z=pt.y;
  }
  
  public void lineTo(Point tPt) {
    line(x,y,z, tPt.x, tPt.y, tPt.z);
  }
}

class Box {
  protected Point cPt;
  protected float length;
  protected float width;
  protected float height;
  
  private float rotateAngle = 0;
  
  public Box() {
    
  }
  public Box(Point center, float len, float wid, float hgt) {
    cPt = center;
    length = len; width = wid; height = hgt;
  }
  
  public void setInitAngle(float angle) {
    rotateAngle = angle;
  }
  
  void show() {
    float tl = length / 2.0;
    float tw = width / 2.0;
    float th = height/ 2.0;
    stroke(color(random(0,255),random(0,255),random(0,255)));
    strokeWeight(random(0,20));
    rotateAngle += random(0,30);
    pushMatrix();
    translate(cPt.x,cPt.y,cPt.z);
    rotate(radians(rotateAngle));
    Point ptULF = new Point(-tl, tw, th);
    Point ptULB = new Point(-tl, -tw, th);
    Point ptURF = new Point(tl, tw,th);
    Point ptURB = new Point(tl, -tw, th);
    Point ptLLF = new Point(-tl, tw, -th);
    Point ptLLB = new Point(-tl, -tw, -th);
    Point ptLRF = new Point(tl, tw, -th);
    Point ptLRB = new Point(tl, -tw, -th);
    ptULF.lineTo(ptURF);ptURF.lineTo(ptURB);ptURB.lineTo(ptULB);ptULB.lineTo(ptULF);
    ptULF.lineTo(ptLLF);ptURF.lineTo(ptLRF);ptURB.lineTo(ptLRB);ptULB.lineTo(ptLLB);
    ptLLF.lineTo(ptLRF);ptLRF.lineTo(ptLRB);ptLRB.lineTo(ptLLB);ptLLB.lineTo(ptLLF);
    popMatrix();
    
  }
}