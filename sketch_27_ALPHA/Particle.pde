/*
  Encapsula el comportamiento básico de una particula en el espacio.
  Estas tienen un origen y una trayectoria que siguen hasta desaparecer.
*/

class Particle {
  
  PVector location;      // Origen.
  PVector velocity;      // Velocidad del movimiento.
  PVector acceleration;  // Aceleración del movimiento.
  float lifespan;        // Toempo de vida.

  color c;

    Particle(PVector l) {
    acceleration = new PVector(0,0.00);
    velocity = new PVector(random(-1,1),random(-1,1),random(-1,1));
    lifespan = 255.0;
    location = l.get();
  }
  
  // Se procede a actualizar las características de la partícula
  //  Posición, forma, color, tanaño.
  //  Luego mostrarla.
  void run() {
    update();
    display();
  }
  
  // En este caso se actualiza la posición.
  void update() {
    //velocity.add(acceleration);
    //location.add(velocity);
    //lifespan = lifespan - 2;
  }

  // Para mostrar una partícula se tienen en cuenta sus atributos. 
  void display() {
    //stroke(255, 0);
    //fill(c, 255);
    pushMatrix();
    translate(location.x,location.y, location.z);
    box(WORLD_SCALE);
    popMatrix();
  }
  
  public void setColor(color c){
    this.c = c;
  }
  
  // Is the particle still useful?
  boolean isDead() {
    return (lifespan < 0.0);
  }
  
}