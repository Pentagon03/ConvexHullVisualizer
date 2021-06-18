//https://github.com/Pentagon03/ConvexHullVisualizer
//Kyungmo Ku
//Convex Hull Visualizer

// Use this for connecting Arduino Controller
// import java.util.ArrayList;
// import processing.serial.*;
// Serial myPort;

//Kyungmo Ku
//I am GOOD!
int N, mxN = 100, cN, flag;
float sx;
Stripe arr[], up[], dn[], ch[];
void setup(){
  smooth();
  strokeWeight(2);
  sx = 20;
  size(1024, 740); 
  fill(255);
  arr = new Stripe[mxN]; N = 0;
  up = new Stripe[mxN];
  dn = new Stripe[mxN];
  ch = new Stripe[mxN];
  ff = createFont("Arial",30);
  textFont(ff); textAlign(CENTER); 
  //myPort = new Serial(this,"COM7",9600);
}

void addStripe(){
  arr[N] = new Stripe(mouseX,mouseY);
  N += 1;
}

void addRandomStripe(){
  arr[N] = new Stripe(random(0,width),random(0,height));
  N += 1;
}

void delStripe(int id){
  if(id<0 || id>=N) return;
 for(int i=id;i<N-1;i++){
   arr[i] = new Stripe(arr[i+1].x,arr[i+1].y);
 }
 N -= 1;
}

void Resize(){
  Stripe tmp[]; tmp = new Stripe[mxN]; 
  for(int i=0;i<N;i++) tmp[i] = arr[i];
  mxN += 30;
  arr = new Stripe[mxN];
  up = new Stripe[mxN];
  dn = new Stripe[mxN];
  ch = new Stripe[mxN];
  for(int i=0;i<N;i++) arr[i] = tmp[i]; 
}

int step = 1, fstep, Mode = 0, pause = 0, gstep = -1;
PFont ff;
boolean cmp(int i,int j){
  if(arr[i].x == arr[j].x)
    return arr[i].y < arr[j].y;
  return arr[i].x < arr[j].x;
}

//Bubble Sort
//Change to O(N lg N) sort if you want it
void sort(){
  for(int i=0;i<N;i++) for(int j=0;j<N-i-1;j++){
    if(!cmp(j,j+1)){
      float x = arr[j+1].x, y = arr[j+1].y;
      arr[j+1].x = arr[j].x;
      arr[j+1].y = arr[j].y;
      arr[j].x = x;
      arr[j].y = y;
    }
  }
  
}

int ccw(Stripe a,Stripe b,Stripe c){
    float res = (b.x-a.x) * (c.y-b.y) - (b.y-a.y) * (c.x-b.x);
    if(abs(res)==0) return 0;
    return res>0?1:-1;
}

void connect(Stripe a, Stripe b){
  stroke(0,0,255);
  line(a.x, a.y, b.x, b.y);
}
void draw(){
  background(255); textSize(36); 
  stroke(0);
  rectMode(CENTER);
  if(Mode!=0){
    if(mouseX>=950-50 && mouseX<=950+50 && mouseY>=700-25 && mouseY<=700+25)
      fill(255,0,0);
    else
      fill(0,0,255);
    rect(950,700,100,50);
    fill(255,255,255);
    text("Home",950,710);
    if(mousePressed && mouseX>=950-50 && mouseX<=950+50 && mouseY>=700-25 && mouseY<=700+25)
      Mode = 0;
  }
  if(Mode==0){
    step = 1; fstep = 0; N = 0; cN = 0; gstep = -1;
    int a=0,b=0,c=255;
    int d=0,e=0,f=255;
    int g=0,h=0,i=255;
    if(mouseX>=512-400 && mouseX<=512+400 && mouseY>=200-20 && mouseY<=200+20){
       a = 255; b = 0; c = 0;
     }else if(mouseX>=512-400 && mouseX<=512+400 && mouseY>=400-20 && mouseY<=400+20){
       d = 255; e = 0; f = 0;
     }else if(mouseX>=512-400 && mouseX<=512+400 && mouseY>=600-20 && mouseY<=600+20){
       g = 255; h = 0; i = 0;
     }
    fill(a,b,c);
    rect(512,200,800,40);
    fill(d,e,f);
    rect(512,400,800,40);
    fill(255,255,255);
    text("Convex Hull Simulator",512,210);
    text("KS - Preprocessing",512,410);
    if(mousePressed){
     if(mouseX>=512-400 && mouseX<=512+400 && mouseY>=200-20 && mouseY<=200+20){
       Mode = 1;
     }else if(mouseX>=512-400 && mouseX<=512+400 && mouseY>=400-20 && mouseY<=400+20){
       Mode = 2;
     }else if(mouseX>=512-400 && mouseX<=512+400 && mouseY>=600-20 && mouseY<=600+20){
       Mode = 3;
     }
    }
  }
  else if(Mode==1){
    textSize(40);fill(0,0,0);
    text("Convex Hull Simulator",512,720);
    if(N == mxN-1) Resize();
    for(int i=0;i<N;i++){
     arr[i].display();
    }
    if(step == 1){
      textSize(30); fill(0);
      text("Step 1: Click to Add Points", 312, 50); 
      text("Current Points: ",312,80);
      delay(50);
      fill(random(0,255),random(0,255),random(0,255));
      text(N,425,80);
      fill(40,0,0,100);
      text("[Enter] -> Next Step", 712,50);
      text("[Backspace] -> Prev Step", 712,80);
      fill(200,0,0);
      for(int i=0;i<N;i++){
        text(i+1, arr[i].x, arr[i].y+10);
      }
      flag = 0;
    }
    
    else if(step == 2){
      textSize(30); fill(0);
      text("Step 2: Sorted Lexicographically", 312, 50); 
      text("<Monotone Chain>",312,80);
      textSize(30); fill(40,0,0,100);
      text("[Enter] -> Next Step", 712,50);
      text("[Backspace] -> Prev Step", 712,80);
      textSize(30);
      sort();
      fill(0,0,200);
      for(int i=0;i<N;i++){
        text(i+1, arr[i].x, arr[i].y+10);
      }
    }
    
    else if(step==3){
      textSize(30); fill(0);
      text("Step 3: Result", 312, 50); 
      textSize(30); fill(40,0,0,100);
      text("[Enter] -> Continue", 712,50);
      text("[P] -> Auto Complete", 712,80);
      textSize(30); fill(0);
      if(N < 3){
        background(255);
        textSize(50); 
        text("Too less points for Convex Hull :v",512,360);
        textSize(30); fill(40,0,0,180);
        text("Press Enter to Continue;",512,390);
        pause = 1;
        return;
      }
      int u=0,d=0;
      for(int i=0;i<N;i++){
          while(u>1 && ccw(up[u-2],up[u-1],arr[i])>0) --u;
          while(d>1 && ccw(dn[d-2],dn[d-1],arr[i])<0) --d;
          up[u++] = arr[i];
          dn[d++] = arr[i];
      }
      cN = 0;
      for(int i=0;i<u;i++) ch[cN++] = up[i];
      for(int i=d-2;i>=0;i--) ch[cN++] = dn[i];
      if(flag==1) fstep = cN-1;
      text(1,ch[0].x,ch[0].y+10);
      for(int i=1;i<=fstep;i++){
        if(i<cN-1) text(i+1, ch[i].x, ch[i].y+10);
        connect(ch[i-1],ch[i]);
      }
      if(fstep==cN-1){
        flag = 1;
        textSize(30); fill(0);
        text("Size: ",312,85);
        delay(50);
        fill(random(0,255),random(0,255),random(0,255));
        text((cN-1),353,85); 
      }
      //if(myPort.available() > 0){
      //  char inByte = myPort.readChar();
      //  println(inByte);
      //  if (inByte == 'A') {
      //    addRandomStripe();
      //    myPort.write('0');
      //  }
      //  if(inByte == 'B'){
      //    delStripe(N-1); 
      //    myPort.write('1');
      //  }
      //}
    }
  }else if(Mode==2){
    fill(0,0,255);
    text("KS - PreProcessing",512,720);
    if(N == mxN-1) Resize();
    for(int i=0;i<N;i++){
     arr[i].display();
    }
    if(step == 1){
      textSize(30); fill(0);
      text("Step 1: Click to Add Points", 312, 50); 
      text("Current Points: ",312,80);
      delay(50);
      fill(random(0,255),random(0,255),random(0,255));
      text(N,425,80);
      fill(40,0,0,100);
      text("[Enter] -> Next Step", 712,50);
      text("[Backspace] -> Prev Step", 712,80);
      fill(200,0,0);
      for(int i=0;i<N;i++){
        text(i+1, arr[i].x, arr[i].y+10);
      }
      gstep = -1;
      delay(10);
    }else if(step==2){
      if(gstep>N-1){
       ++step; return; 
      }
       if(gstep!=-1){
         Stripe p = arr[gstep];
         stroke(0);
         line(0,p.y,width,p.y); line(p.x,0,p.x,height);
         int a=0,b=0,c=0,d=0;
         for(int i=0;i<N;i++){
          if(i==gstep) continue;
          float x = arr[i].x, y = arr[i].y;
          if(x>p.x && y>p.y && a==0) {a=1; arr[i].flag = true;}
          if(x>p.x && y<p.y && b==0){b=1; arr[i].flag = true;}
          if(x<p.x && y>p.y && c==0){c=1; arr[i].flag = true;}
          if(x<p.x && y<p.y && d==0){d=1; arr[i].flag = true;}
         }
         if(a==1 && b==1 && c==1 && d==1) delStripe(gstep);
       }
       if(gstep == N)
         ++step;
    }
    if(step==3){
      for(int i=0;i<N;i++) arr[i].display();
      textSize(50); fill(0);
      text("DONE",512,370);
    }
  }
}

void mousePressed(){
  if(Mode!=1 && Mode!=2) return;
  if(Mode == 2 && step==2) return;
  int id = -1;
  for(int i=0;i<N;i++){
    if(arr[i].isIn()){
      id = i; break;
    }
  }
  if(id == -1) addStripe();
  else delStripe(id);
  if(step==3) sort();
}

void keyPressed(){
  if(Mode == 1 && key == ENTER && step < 3) ++step; 
  if(Mode == 2 && key == ENTER && step < 2) ++step;
  if(Mode == 1 && key == ENTER && step == 3 && fstep < cN-1) ++fstep;
  if(Mode == 1 && key == ENTER && pause == 1){
    pause = 0; step = 1;
  }
  if(Mode == 2 && step == 2 && key == ENTER && gstep < N){ ++gstep;
    for(int i=0;i<N;i++) arr[i].flag = false;
  }
  if((key == 'p' || key == 'P') && step == 3) fstep = cN-1;
  if(key == BACKSPACE && step > 1) --step;
}
