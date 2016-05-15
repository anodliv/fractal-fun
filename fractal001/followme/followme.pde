
float x = 100;
float y = 100;
float segLength = 20;
ArrayList<Follower> followChain; 
void setup() {
  size(800, 600);
  strokeWeight(10.0);
  stroke(255, 100);
  followChain = new ArrayList<Follower>();
  followChain.add( new Follower(x,y, segLength));

}

void draw() {
  background(255);
  for(int i = 0; i < followChain.size(); i++) {
    followChain.get(i).show();
  }
  
}

void mousePressed() {
  if (mouseButton == LEFT) {
    // left button click to add at the tail
    Follower nf = new Follower(mouseX, mouseY, segLength);
    nf.followes(followChain.get(followChain.size() -1));
    followChain.add(nf);
  } else if (mouseButton == RIGHT && followChain.size() > 1) {
    // right button click to remove at the tail
    Follower lf = followChain.get(followChain.size() -2);
    lf.followedBy(null);
    followChain.remove(followChain.size()-1);
  }
}

void mouseMoved() {
  followChain.get(0).follow(mouseX, mouseY);
}

class Follower {
  private Follower follower, following;
  private color fColor = color(random(255),random(255),random(255));
  public float px, py, length, angle;
  public Follower(float sx, float sy, float len) {
    px = sx; py = sy; length = len;
  }
  
  public void followes(Follower _follower) {
    following = _follower;
    _follower.followedBy(this);
  }
  
  public void followedBy(Follower _follower) {
    follower = _follower;
  }
  
  
  public void follow(float mx, float my) {
    float dx = mx - px;
    float dy = my - py;
    angle = atan2(dy, dx);  
    px = mx - (cos(angle) * length);
    py = my - (sin(angle) * length);

    // inform the follower
    if(follower != null) { 
      follower.follow(px,py);
    }
  }
 
  
  public void show() {
    stroke(fColor, 100);
    pushMatrix();
    translate(px, py);
    rotate(angle);
    line(0, 0, length, 0);
    popMatrix();
    fill(fColor);
    ellipse(px, py, 10, 10);
  }
}