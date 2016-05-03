int k = 60;
Complex initC, initC2;
color[] colors;
JuliaFractal jf, jf2;
void setup()
{
  int mx = 1200;
  int my = 600;
  initC = new Complex(-0.01,1);
  initC2 = new Complex(-1.485, 1.156);
  
  jf = new JuliaFractal(mx/2,my,-1.5,1.5,-1,1,initC);
  jf2 = new JuliaFractal(mx/2,my,-1.5,1.5,-1,1,initC2);

  surface.setSize(mx,my);
  background(255);
  colors = new color[k+1];
  for(int i =0;i<=k;i++) {
    colors[i] = color(random(0,255),random(0,255),random(0,255));
  }
  colorMode(HSB, k, 100,100);
  smooth();
 
}

color getcolor(int seed) {
  return color(0, 0, seed*2);
}

void draw() {
  
  jf.draw();
  translate(600,0);
  jf2.draw();
  noLoop();
}

void keyPressed() {

}

class JuliaFractal {
  protected int width, height;
  protected float xs,xl,ys,yl;
  protected Complex initC;
  
  public JuliaFractal(int wid, int hgt, float xmin, float xmax, float ymin, float ymax, Complex c) {
    width = wid; height = hgt; xs = xmin; xl = xmax; ys = ymin; yl = ymax; initC = c;
  }
  public void draw() {
    Complex z = new Complex();
    float xStep = (xl-xs)/width;
    float yStep = (yl-ys)/height;
    for(int i = 0; i< width; i++) {
      for(int j =0; j< height; j++) {
        z.r = xs + i*xStep;
        z.i = ys + j*yStep;
        int ik;
        for(ik = 0; ik < k; ik++) {
          if(z.length() > 3) break;
          else {
            z = z.multiply(z).add(initC);
          }
        }
        stroke(color(ik,80,95));
        point(i,j);
      }
    }
  
  }
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