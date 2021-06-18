class Stripe {
  float x, y;     // horizontal location of stripe
  float w;     // width of stripe
  float r, g, b, alpha;
  
  // A boolean variable keeps track of the object's state.
  boolean mouse; // state of stripe (mouse is over or not?)
  boolean ignore;
  boolean flag;
  Stripe(float _x,float _y) {
    ignore = false;
    // All stripes start at 0
    x = _x;
    y = _y;
    w = 15;
    r = 200;
    g = 200;
    b = 200;
    alpha = 200;
    mouse = false;
    flag = false;
  }
  void toggle(){
    flag = !flag; 
  }
  boolean isIn(){
    return dist(mouseX,mouseY,x,y) <= w;
  }
  // Draw stripe
  void display() {
    // Boolean variable determines Stripe color.
    // is in circle
    if(flag){
      fill(255,0,0); 
    }
    else if(isIn() == false){
      // is not in circle
      fill(r, g, b, alpha);
    }else{
     fill(70,0,0,160);
    }
    noStroke();
    ellipseMode(RADIUS);
    ellipse(x, y, w, w);
  }
}
