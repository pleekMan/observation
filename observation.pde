import processing.net.*;

Server s;

PImage plante_illus;
PImage plante_descr;

Timer timer_description;
Timer timer_newPlant;
boolean isChangingPlant = false;

//PImage[] illustrations;
//PImage[] descriptions;

int planteCount = 3;
int enPlante = 0;

float opacity = 1;

boolean illustrationMode = true;
float fadeVel = 0.02;

int threshold = 50; // (99 cm APROX)

void setup() {
  size(360, 640);
  frameRate(30);  

  //for(int i=0; i < planteCount; i++){
  //  illustrations[i] = loadImage("_" + i + "illustration.png");
  //  descriptions[i] = loadImage("_" + i + "descriptions.png");
  //}

  s = new Server(this, 12000);

  timer_description = new Timer();
  timer_description.setDurationInSeconds(2); // 5
  timer_newPlant = new Timer();
  timer_newPlant.setDurationInSeconds(8);

  loadPlante(0);
}


void draw() {
  background(0);

  // CHECK IF GOT SOMETHNG FROM PYTHON CLIENT

  //int sensorData = getSensorData();
  int sensorData = floor(map(mouseY, height, 0, 100, 0)); // SIMULATED WITH MOUSE

  if (!isChangingPlant) {

    // DECLENCHER LE FADING IF USER PASSES LE SEUIL
    if (sensorData < threshold && illustrationMode) {
      illustrationMode = false;
      timer_description.start();
      //println("TIMER DESCRIPTION : STARTED");
    }

    // DIRECTION OF FADING
    if (!illustrationMode) {
      opacity += fadeVel;
    } else {
      opacity -= fadeVel;
    }

    // TOUJOURS RESTRAINT
    opacity  = constrain(opacity, 0, 1);


    if (timer_description.isFinished()) {

      if (!illustrationMode) {
        timer_newPlant.start();
        //println("TIMER DESCRIPTION : END");
        //println("TIMER NEW PLANT : STARTED");
      }

      illustrationMode = true;
    }


    if (timer_newPlant.isFinished()) {
      isChangingPlant = true;
      loadNextPlantAsTransition();
      //println("PLANT TRANSITION : STARTED");
    }
  } else {

    opacity += fadeVel;

    if (opacity >= 1.0) {
      loadNextPlante();
      opacity = 0;
      isChangingPlant = false;
      illustrationMode = true;
      timer_newPlant.start();
      //println("PLANT TRANSITION : FINISHED");
    }
  }


  tint(255);
  image(plante_illus, 0, 0);

  tint(255, opacity * 255);
  image(plante_descr, 0, 0);

  fill(255, 0, 0);
  //text(opacity, 10, 10);
  //text(sensorData, 100, 10);
}

int getSensorData() {
  Client c = s.available();
  if (c != null) {
    String input = c.readString();
    int clampedInput = constrain(int(input), 0, 100);
    //println(input);
    return clampedInput;
  } else {
    return 9999; // EXTREMELY HIGH NUMBER. WAY OUT OF THE SENSOR THRESHOLD
  }
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

void loadNextPlantAsTransition() {
  int nextPlante = enPlante + 1 < planteCount ? enPlante + 1 : 0;
  // TEMPORARILY LOADING NEXT PLANT IMAGE ON plante_description PImage
  plante_descr = loadImage("plantes/_" + nextPlante + "_illustration.png");
  opacity = 0;
}
