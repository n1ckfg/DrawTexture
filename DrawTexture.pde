PImage img;
PShape brush;
float dim = 1;
float scaler = 5;
float lerpSpeed = 0.2;
PVector target;
int alphaVal = 40;
PGraphics gfx, gfx2, gfx3;
boolean armInit = false;
float mouseSpread = 50;

void setup() {
  size(800, 600, P2D);
  img = loadImage("brush.png");
  init();
}

void init() {
  gfx = createGraphics(width, height, P2D);
  gfx2 = createGraphics(width/10, height/10, P2D);
  gfx3 = createGraphics(width/100, height/100, P2D);
}

void keyPressed() {
  armInit = true;
}

void draw() {
  if (armInit) {
    init();
    armInit = false;
  }
  
  background(0);
  
  if (mousePressed) {
    dim = dist(mouseX, mouseY, pmouseX, pmouseY) / scaler;
    target.lerp(new PVector(mouseX, mouseY), lerpSpeed);
    
    brush.beginShape(QUAD_STRIP);
    brush.tint(0, 127, 255, alphaVal);
    brush.vertex(mouseX - dim, mouseY - dim, 0, 0);
    brush.vertex(mouseX + dim, mouseY - dim, 0, 1);
    brush.vertex(mouseX + dim, mouseY + dim, 1, 0);
    brush.vertex(mouseX - dim, mouseY + dim, 1, 1);
    brush.vertex(mouseX - dim, mouseY - dim, 0, 0);
    
    brush.tint(255, 127, 0, alphaVal);
    brush.vertex(target.x - dim, target.y + dim, 1, 1);
    brush.vertex(target.x - dim, target.y - dim, 0, 0);
    brush.vertex(target.x + dim, target.y - dim, 0, 1);
    brush.vertex(target.x + dim, target.y + dim, 1, 0);
    brush.endShape();
    
    gfx.beginDraw();
    gfx.shape(brush);
    gfx.endDraw();
 
    gfx2.beginDraw();
    gfx2.image(gfx, 0, 0, gfx2.width, gfx2.height);
    gfx2.filter(BLUR);
    gfx2.endDraw();

    gfx3.beginDraw();
    gfx3.image(gfx, 0, 0, gfx3.width, gfx3.height);
    gfx3.filter(BLUR);
    gfx3.endDraw();
  }
  
  blendMode(BLEND);
  image(gfx3, 0, 0, width, height);

  blendMode(SUBTRACT);
  image(gfx2, 0, 0, width, height);

  blendMode(ADD);
  image(gfx, 0, 0, width, height);
  
  surface.setTitle("" + frameRate);
}

void mousePressed() {
  float newX = mouseX + random(mouseSpread) - random(mouseSpread);
  float newY = mouseY + random(mouseSpread) - random(mouseSpread);
  target = new PVector(newX, newY);

  brush = createShape();
  brush.beginShape();
  brush.noFill();
  brush.noStroke();
  brush.texture(img);
  brush.textureMode(NORMAL);
  brush.endShape();
}
