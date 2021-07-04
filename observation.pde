import processing.net.*;

Server s;

PImage plante_illus;
PImage plante_descr;

//PImage[] illustrations;
//PImage[] descriptions;

int planteCount = 3;
int enPlante = 0;

float opacity = 0;

void setup() {
  size(360, 640);

  //for(int i=0; i < planteCount; i++){
  //  illustrations[i] = loadImage("_" + i + "illustration.png");
  //  descriptions[i] = loadImage("_" + i + "descriptions.png");
  //}

  s = new Server(this, 12000);

  loadPlante(0);
}


void draw() {
  background(0);
  
  // CHECK IF GOT SOMETHNG FROM PYTHON CLIENT
  Client c = s.available();
  if (c != null) {
    String input = c.readString();
    println(input);
    
    opacity = map(int(input), 0, 1023, 0,1);
  }

  tint(255);
  image(plante_illus, 0, 0);

  tint(255, opacity * 255);
  image(plante_descr, 0, 0);

  text(opacity, 10, 10);
}

void keyPressed() {

  if (key == ' ') {
    loadNextPlante();
  }
}


void loadNextPlante() {

  enPlante = enPlante + 1 < planteCount ? enPlante + 1 : 0;
  //println("EnPlante => " + enPlante);
  loadPlante(enPlante);
}

void loadPlante(int index) {
  plante_illus = loadImage("plantes/_" + index + "_illustration.png");
  plante_descr = loadImage("plantes/_" + index + "_description.png");
}
