int mx, my;
float xs, xl;
float ys, yl;
float xStep, yStep;
int k = 126;
Complex initC;
Complex z;
color[] colors;
void setup()
{
  mx = 1500; my = 900;
  xs = -1.0; xl = 1.0;
  ys = -1.0; yl = 1.0;
  xStep = (xl-xs)/mx;
  yStep = (yl-ys)/my;
  initC = new Complex(-0.8,0.156);
  z = new Complex();  
  surface.setSize(mx,my);
  background(255);
  colors = new color[k+1];
  for(int i =0;i<=k;i++) {
    colors[i] = color(random(0,255),random(0,255),random(0,255));
  }
  smooth();
}

color getcolor(int seed) {
  return color(0, 0, seed*2);
}

void draw() {
  
  for(int i = 0; i< mx; i++) {
    for(int j =0; j< my; j++) {
      z.r = xs + i*xStep;
      z.i = ys + j*yStep;
      int ik;
      for(ik = 0; ik < k; ik++) {
        if(z.length() > 3) break;
        else {
          z = z.multiply(z).add(initC);
        }
      }
      //stroke(ik);
      //stroke(colors[ik]);
      stroke(getcolor(ik));
      point(i,j);
    }
  }
  noLoop();
}

void keyPressed() {

}

class Complex {
  public float r;
  public float i;
  
  public Complex() {
    r = 0; i = 0;
  }
  
  public Complex(float real, float impl) {
    r = real; i = impl;
  }
  
  public Complex(Complex cp) {
    r = cp.r; i = cp.i;
  }
  
  public Complex multiply (Complex cm) {
    Complex c = new Complex();
    c.r = r * cm.r - i * cm.i;
    c.i = i * cm.r + r * cm.i;
    return c;
  }
  
  public Complex add(Complex ca) {
    Complex c = new Complex();
    c.r = r + ca.r;
    c.i = i + ca.i;
    return c;
  }

  public float length() {
    return sqrt(r*r + i*i);
  }
  
}