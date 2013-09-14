import java.io.*;
import processing.serial.*;
import mindset.*;

Neurosky neurosky = new Neurosky();
String com_port = "/dev/tty.MindWave";


boolean gameStart = false;
 
float x = 150;
float y = 150;
float speedX = random(3, 5);
float speedY = random(3, 5);
color leftColor, rightColor;
color standard_fill = color(29,162,240);
int diam;
int rectSize = 150;

 
 
void setup() {
  size(500, 500);
  noStroke();
  smooth();
  ellipseMode(CENTER);
  
  leftColor = standard_fill;
  rightColor = standard_fill;
  
  neurosky.initialize(this,com_port);
}
 
void draw() {
  background(31,33,41);
  
  neurosky.update();
 
  fill(standard_fill);
  diam = 20;
  ellipse(x, y, diam, diam);
 
  fill(leftColor);
  rect(0, 0, 20, height);
  fill(rightColor);
  float paddle_y = map(neurosky.attn_pulse, 0, 100, 0, height);
  rect(width-30, paddle_y-rectSize/2, 10, rectSize);
 
 
  if (gameStart) {
 
    x = x + speedX;
    y = y + speedY;
 
    // if ball hits movable bar, invert X direction and apply effects
    if ( x > width-30 && x < width -20 && y > paddle_y-rectSize/2 && y < paddle_y+rectSize/2 ) {
      speedX = speedX * -1;
      x = x + speedX;
      rightColor = color(182,167,0);
      rectSize = rectSize-10;
      rectSize = constrain(rectSize, 10,150);     
    }
 
    // if ball hits wall, change direction of X
    else if (x < 25) {
      speedX = speedX * -1.1;
      x = x + speedX;
      leftColor = color(182,167,0);
    }
 
    else {    
      leftColor = standard_fill;
      rightColor = standard_fill;
    }
    // resets things if you lose
    if (x > width) {
      gameStart = false;
      x = 150;
      y = 150;
      speedX = random(3, 5);
      speedY = random(3, 5);
      rectSize = 150;
    }
 
 
    // if ball hits up or down, change direction of Y  
    if ( y > height || y < 0 ) {
      speedY = speedY * -1;
      y = y + speedY;
    }
  }
}
void mousePressed() {
  gameStart = !gameStart;
}
