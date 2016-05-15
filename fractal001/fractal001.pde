Complex initC;
color[] colors;
int mouseStartX, mouseStartY;
int mouseEndX, mouseEndY;
int mx = 1280;
int my = 960;
int nk = 200;
int iMode = 0; //0: julia, 1: mandelbrot
int iColorMode = 0; // 0: sequential, 1: random
boolean bJuliaReady = false, bMandelReady = false;
PGraphics pgJulia, pgMandel;
JuliaFractal jf, jf2;
MandelbrotFractal mf;

void setup()
{
  initC = new Complex(random(-1,1),random(-1,1));
  
  jf = new JuliaFractal(mx,my,-1.5,1.5,-1.2,1.2, nk, initC);
  mf = new MandelbrotFractal(mx,my,-2.3, 1.0,-1.3,1.3, nk, 500);

  surface.setSize(mx,my);
  colorMode(HSB, nk, 100,100);
  colors = new color[nk+1];
  for(int i =0;i<=nk;i++) {
   colors[i] = color(random(0,nk),random(0,100),random(0,100));
  }
  smooth();
  rectMode(CORNERS);
  pgJulia = createGraphics(mx,my);
  pgMandel = createGraphics(mx,my);

}

color getcolor(int seed) {
  return color(0, 0, seed*2);
}

void draw() {
  background(255);
  if (iMode == 0) {
    if (! bJuliaReady) {
       bJuliaReady = jf.draw(pgJulia);
    }
    image(pgJulia, 0, 0);
  } else if(iMode == 1) {
    if (! bMandelReady) {
        bMandelReady = mf.draw(pgMandel);
    }
    image(pgMandel, 0, 0);
  }
  noFill();
  rect(mouseStartX, mouseStartY, mouseEndX, mouseEndY);
}

void keyPressed() {
  if(key == 'j' || key == 'J') {
    iMode = 0;
  } else if(key== 'm' || key=='M') {
    iMode = 1;
  } else if(key == '1') {
    iColorMode = 0;
  } else if (key == '2') {
    iColorMode = 1;
  } else if (key == 'r' || key == 'R') {
    // preventing re-enter-draw, only one draw at a time
    if(bJuliaReady && iMode == 0) {
      jf.reset();
      bJuliaReady = false;
    } else if(bMandelReady && iMode == 1) {
      mf.reset();
      bMandelReady = false;
    }
  } else if(key =='n' || key=='N') {
    if(bJuliaReady && iMode == 0) {
      jf = new JuliaFractal(mx,my,-1.5,1.5,-1.2,1.2, 200, new Complex(random(-1,1),random(-1,1)));
      bJuliaReady = false;
    } else if(bMandelReady && iMode == 1) {
      mf = new MandelbrotFractal(mx,my,-1.5,1.5,-1.2,1.2, 200,500);
      bMandelReady = false;
    }
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
  if ((mouseEndX - mouseStartX) >= 5 && (mouseEndY - mouseStartY) >= 5) {
    if(iMode == 0) {
      jf.setViewPort(mouseStartX, mouseEndX, mouseStartY, mouseEndY);
      bJuliaReady = false;
    } else if(iMode == 1) {
      mf.setViewPort(mouseStartX, mouseEndX, mouseStartY, mouseEndY);
      bMandelReady = false;
    }
    print("\n mouse rect: x,y,x1,y1:" + mouseStartX + "," + mouseStartY + "," + mouseEndX + "," + mouseEndY);
  }
  // reset
  mouseStartX = mouseStartY = mouseEndX = mouseEndY = 0;
}

class KochFractal extends Fractal {
  protected Point2D sp; // start point
  protected Point2D ep; // end point
  protected float alpha; // the angle
  protected float stop; // the stop point
  protected KochFractal() {
  }
  public KochFractal(int wid, int hgt, Point2D ptStart, Point2D ptEnd, float angle, float stopSize) {
    super(wid, hgt);
    sp = ptStart; ep = ptEnd; alpha = angle; stop = stopSize;
  }
}

class MandelbrotFractal extends JuliaFractal
{
  protected double em;
  public MandelbrotFractal(int wid, int hgt, double xmin, double xmax, double ymin, double ymax, int escapeTime, double escapeRadius) {
    super(wid,hgt,xmin,xmax, ymin,ymax, escapeTime, new Complex());
    em = escapeRadius;
  }
  
  public boolean draw(PGraphics pg)  {
    if(pg != null) {
      pg.beginDraw();
      pg.background(0);
    }
    Complex z = new Complex();
    Complex ct = new Complex();
    double xStep = (xl-xs)/width;
    double yStep = (yl-ys)/height;
    for(int i = 0; i< width; i++) {
      for(int j =0; j< height; j++) {
        z.r = xs + i*xStep;
        z.i = ys + j*yStep;
        int ik;
        ct.set(0,0);
        for(ik = 0; ik < ek; ik++) {
          if(ct.length() > em) break;
          else {
            ct = ct.multiply(ct).add(z);
          }
        }
        if (pg != null) { 
          pg.stroke(getColor(ik));
          pg.point(i,j);
        } else {
          stroke(getColor(ik));
          point(i,j);
        }
      }
    }
    if (pg != null) {
      pg.fill(255,244,255);
      pg.text("vp:" + xs + "," + ys + "," + xl + "," + yl, 5, 15);
    } else {
      fill(255,244,255);
      text("vp:" + xs + "," + ys + "," + xl + "," + yl, 5, 15);
    }
    if (pg != null) {
      pg.endDraw();
    }

    
    return true;
  }
  
}

class JuliaFractal extends Fractal {
  protected double xs,xl,ys,yl;
  protected Complex initC;
  protected int ek;
  // original values for reset zoom
  protected Complex oInitC;
  protected double oxs,oxl,oys,oyl;
  
  
  protected JuliaFractal() {}
  
  public JuliaFractal(int wid, int hgt, double xmin, double xmax, double ymin, double ymax, int escapeTime, Complex c) {
    super(wid,hgt);
    xs = xmin; xl = xmax; ys = ymin; yl = ymax; initC = c; ek = escapeTime;
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
    double xStep = (xl-xs)/width;
    double yStep = (yl-ys)/height;
    double nxs = xs + wxs * xStep;
    double nys = ys + wys * yStep;
    double nxm = xs + wxm * xStep;
    double nym = ys + wym * yStep;
    xs = nxs; ys = nys; xl = nxm; yl = nym;
    print("\n new viewport:" + xs + "," + ys + "," + xl + "," + yl);
  }
  public boolean draw(PGraphics pg) {
    if(pg != null) {
      pg.beginDraw();
      pg.background(0);
    }
    Complex z = new Complex();
    double xStep = (xl-xs)/width;
    double yStep = (yl-ys)/height;
    for(int i = 0; i< width; i++) {
      for(int j =0; j< height; j++) {
        z.set(xs + i*xStep,ys + j*yStep);
        int ik;
        for(ik = 0; ik < ek; ik++) {
          if(z.length() > 2) break;
          else {
            z = z.multiply(z).add(initC);
          }
        }
        if (pg != null) { 
          pg.stroke(getColor(ik));
          pg.point(i,j);
        } else {
          stroke(getColor(ik));
          point(i,j);
        }
      }
    }
    if (pg != null) {
      pg.fill(255,244,255);
      pg.text("vp:" + xs + "," + ys + "," + xl + "," + yl+", init:"+initC.toString(), 5, 15);
    } else {
      fill(255,244,255);
      text("vp:" + xs + "," + ys + "," + xl + "," + yl+", init:"+initC.toString(), 5, 15);
    }
    if (pg != null) {
      pg.endDraw();
    }
    return true;
  }
  
}

class Fractal {
  // the view window size
  protected int width, height;
  protected Fractal() {}
  protected Fractal(int wd, int ht) {
    width = wd; height = ht;
  }

  protected color getColor(int index) {
    if (iColorMode == 1) return colors[index];
    return color(index, 70,90);
  }
}

class Complex {
  public double r;
  public double i;
  
  public Complex() {
    r = 0; i = 0;
  }
  
  public Complex(double real, double impl) {
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

  public void set(double real, double impl) {
    r = real; i = impl;
  }
  
  public double length() {
    return sqrt((float)(r*r + i*i));
  }
  
  public String toString() {
    String ext = i >= 0 ? "+" : " ";
    return r + ext + i + "i";
  }
}

class Point2D {
  public double x;
  public double y;
  
  protected Point2D() {
  }
  
  public Point2D(double _x, double _y) {
    x = _x; y = _y;
  }
  
  public Point2D(Point2D pt) {
    x = pt.x; y = pt.y;
  }
  
  public double distanceTo(Point2D pt) {
    double xd = x - pt.x; 
    double yd = y - pt.y;
    return sqrt((float)(xd * xd + yd * yd));
  }
  
  public void lineTo(Point2D pt) {
    line((float)x,(float)y, (float)pt.x,(float)pt.y);
  }
  
}