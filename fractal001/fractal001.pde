int k = 60;
Complex initC, initC2;
color[] colors;
JuliaFractal jf, jf2;
int mouseStartX, mouseStartY;
int mouseEndX, mouseEndY;
boolean bJuliaReady = false;
PGraphics pgJulia;
int mx = 1200;
int my = 900;

void setup()
{
  initC = new Complex(-0.85,0.156);
  //initC2 = new Complex(-1.485, 1.156);
  
  jf = new JuliaFractal(mx,my,-1.5,1.5,-1,1,initC);
  //jf2 = new JuliaFractal(mx/2,my,-1.5,1.5,-1,1,initC2);

  surface.setSize(mx,my);
  colors = new color[k+1];
  for(int i =0;i<=k;i++) {
    colors[i] = color(random(0,255),random(0,255),random(0,255));
  }
  colorMode(HSB, k, 100,100);
  smooth();
  rectMode(CORNERS);
  pgJulia = createGraphics(mx,my);
}

color getcolor(int seed) {
  return color(0, 0, seed*2);
}

void draw() {
  background(255);
  if (! bJuliaReady) {
      bJuliaReady = jf.draw(pgJulia);
  }
  image(pgJulia, 0, 0);
  noFill();
  rect(mouseStartX, mouseStartY, mouseEndX, mouseEndY);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    jf.reset();
    bJuliaReady = false;
  }
}

void mousePressed() {
  // set the starting corner
  mouseStartX = mouseX; mouseStartY = mouseY;
}

void mouseDragged() {
  mouseEndX = mouseX; mouseEndY = mouseY;
}

void mouseReleased() {
  mouseEndX = mouseX; mouseEndY = mouseY;
  jf.setViewPort(mouseStartX, mouseEndX, mouseStartY, mouseEndY);
  bJuliaReady = false;
  print("\n mouse rect: x,y,x1,y1:" + mouseStartX + "," + mouseStartY + "," + mouseEndX + "," + mouseEndY);
  // reset
  mouseStartX = mouseStartY = mouseEndX = mouseEndY = 0;
}

class JuliaFractal {
  protected int width, height;
  protected float xs,xl,ys,yl;
  protected Complex initC;
  // original values for reset zoom
  protected Complex oInitC;
  protected float oxs,oxl,oys,oyl;
  
  
  public JuliaFractal(int wid, int hgt, float xmin, float xmax, float ymin, float ymax, Complex c) {
    width = wid; height = hgt; xs = xmin; xl = xmax; ys = ymin; yl = ymax; initC = c;
    oxs = xs; oxl = xl; oys = ys; oyl = yl;
    oInitC = initC;
    print("\n init viewport:" + xs + "," + ys + "," + xl + "," + yl);
  }
  
  public void reset() {
    xs = oxs; ys = oys; yl = oyl; xl = oxl;
    initC = oInitC;
    print("\n reset viewport:" + xs + "," + ys + "," + xl + "," + yl);
  }
  
  // set the new viewport, for zoom in
  public void setViewPort(int wxs, int wxm, int wys, int wym) {
    float xStep = (xl-xs)/width;
    float yStep = (yl-ys)/height;
    float nxs = xs + wxs * xStep;
    float nys = ys + wys * yStep;
    float nxm = xs + wxm * xStep;
    float nym = ys + wym * yStep;
    xs = nxs; ys = nys; xl = nxm; yl = nym;
    print("\n new viewport:" + xs + "," + ys + "," + xl + "," + yl);
  }
  public boolean draw(PGraphics pg) {
    if(pg != null) {
      pg.beginDraw();
      pg.background(0);
    }
    Complex z = new Complex();
    float xStep = (xl-xs)/width;
    float yStep = (yl-ys)/height;
    for(int i = 0; i< width; i++) {
      for(int j =0; j< height; j++) {
        z.r = xs + i*xStep;
        z.i = ys + j*yStep;
        int ik;
        for(ik = 0; ik < k; ik++) {
          if(z.length() > 2) break;
          else {
            z = z.multiply(z).add(initC);
          }
        }
        if (pg != null) { 
          pg.stroke(color(ik,80,95));
          pg.point(i,j);
        } else {
          stroke(color(ik,80,95));
          point(i,j);
        }
      }
    }
    if (pg != null) {
      pg.endDraw();
    }
    return true;
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