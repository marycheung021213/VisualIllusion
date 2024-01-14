import controlP5.*;
import java.util.*;

int mX=40, mY=40; // bleeding
int btnWidth=120, btnHeight=40, btnGap=40; // button size

int maxGrid=480, minGrid=15; // rect size
int grid=maxGrid;
float[] directionsDefault={-1, -1, 1, -1, -1, 1, 1, 1}; // rotating directions
float[] directionsUsed=directionsDefault;
color blackAndWhite[]={color(245, 245, 245), color(245, 245, 245), color(245, 245, 245), color(245, 245, 245)}; // rect color
color bayerFilter[]={color(0, 255, 0), color(255, 0, 0), color(0, 0, 255), color(0, 255, 0)};
color[] colorsUsed=blackAndWhite;
float angle;
boolean scaleFlag=true;
boolean colorFlag=true;

ControlP5 cp5;
RotatePattern pattern;

void setup(){
  size(1040, 1120, P3D);
  
  // rect setup
  rectMode(CENTER);
  noStroke();
  
  // gui setup
  guiSetup(new String[]{"reset", "change", "original", "colorMode"}, "Arial", 14);
}

void draw(){
  background(#232323);
  
  // draw rotated rects
  pattern=new RotatePattern();
  pattern.directions=directionsUsed;
  pattern.colors=colorsUsed;
  pattern.rotateRects();
  pattern.startRotate();
}

public void reset(){
  pattern.reset();
}

public void change(){
  pattern.changePattern();
}

public void original(){
  pattern.changeDefault();
}

public void colorMode(){
  if(colorFlag){
    pattern.changeColored();
    colorFlag=!colorFlag;
  }else{
    pattern.changeGray();
    colorFlag=!colorFlag;
  }
}

class RotatePattern{
  float[] directions;
  color[] colors;
  float speedArg=1;
  float scaleArg=2;
  
  // start rotating
  public void startRotate(){
    if(scaleFlag){
      angle+=speedArg;
      if(angle>=180){
        grid/=scaleArg;
        if(grid<minGrid){
          grid=minGrid;
          scaleFlag=false;
        }
        angle=0;
      }
    }else{
      angle-=speedArg*1;
      if(angle<=0){
        grid*=scaleArg;
        if(grid>maxGrid){
          grid=maxGrid;
          scaleFlag=true;
        }
        angle=180;
      }
    }
  }
  
  // arrange rects' positions and directions
  public void rotateRects(){
    for(int x=mX+grid; x<=width-mX; x+=grid*2){
      for(int y=mY+grid; y<=height-mY-btnHeight-btnGap; y+=grid*2){
        push();
        translate(x,y);
        // top-left
        fill(colors[0]);
        rotateRect(-grid/2, -grid/2, directions[0]*angle, directions[1]*angle, true);
        // top-right
        fill(colors[1]);
        rotateRect(grid/2, -grid/2, directions[2]*angle, directions[3]*angle, false);
        // bottom-left
        fill(colors[2]);
        rotateRect(-grid/2, grid/2, directions[4]*angle, directions[5]*angle, false);
        // bottom-right
        fill(colors[3]);
        rotateRect(grid/2, grid/2, directions[6]*angle, directions[7]*angle, true);
        pop();
      }
    }
  }
  
  // rotate a rect
  private void rotateRect(float translateX, float translateY, float rotateXAngle, float rotateYAngle, boolean XFirst){
    push();
    translate(translateX, translateY);
    if(XFirst){
      rotateX(radians(rotateXAngle));
      rotateY(radians(rotateYAngle));
    }else{
      rotateY(radians(rotateYAngle));
      rotateX(radians(rotateXAngle));
    }
    rect(0, 0, grid, grid);
    pop();
  }
  
  public void reset(){
    grid=maxGrid;
    angle=0;
    scaleFlag=true;
  }
  
  public void changePattern(){
    float[] newdirections=new float[8];
    for(int i=0; i<directions.length; i++){
      double randDouble=Math.random();
      if(randDouble<0.5){
        //directions[i]*=-1;
        newdirections[i]=directions[i]*-1;
      }else{
        newdirections[i]=directions[i];
      }
    }
    directionsUsed=newdirections;
    reset();
  }
  
  public void changeDefault(){
    directionsUsed=directionsDefault;
    reset();
  }
  
  public void changeGray(){
    colorsUsed=blackAndWhite;
  }
  
  public void changeColored(){
    colorsUsed=bayerFilter;
  }
}

void guiSetup(String[] names, String fontType, int fontSize){
  PFont pfont = createFont(fontType,fontSize);
  ControlFont font = new ControlFont(pfont);
  cp5=new ControlP5(this);
  int btnX=mX;
  int btnY=height-mY-btnHeight;
  for(int i=0; i<names.length; i++){
    if(i>=1){
      btnX+=btnWidth+btnGap;
    }
    cp5.addButton(names[i])
       .setPosition(btnX, btnY)
       .setSize(btnWidth, btnHeight)
       .setFont(font)
       .setColorBackground(color(125, 125, 125))
       .setColorForeground(color(175, 175, 175))
       .setColorActive(color(100, 100, 100));
  }
}
