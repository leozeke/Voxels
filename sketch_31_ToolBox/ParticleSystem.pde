/*
  Esta clase representa un sistema de partículas que se despliega desde la posición origen.
  En este caso el sistema se ha simplificado a una sola partícula.
  La partícula dibujada en este caso es un cubo.
*/

class ParticleSystem {

  ArrayList<Particle> particles;     // Una lista de partículas.
  Particle p;                        // Una de las partículas del sistema.
  boolean isSelected;                // Si el sistema está seleccionado.
  color c;                           // Color base del sistema.
  int SIZE = WORLD_SCALE;            // Longitud del volumen de colisión.
  private PVector origin;            // Origen del sistema

  ParticleSystem(PVector v, color c) {
    origin = v;        
    this.c = c;
    isSelected = false;
    particles = new ArrayList<Particle>();
    addParticle(); 
  }
  
  void run() {
    // Cicla sobre la estructura para actualizar el estado de cada partícula.
    for (int i = particles.size()-1; i >= 0; i--) {
      p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
    //addParticle();
  }
  
  void addParticle() {
    p = new Particle(origin);
    p.setColor(c);
    particles.add(p);
  }
  
  // Dibujar un sistema de partículas.
  void draw() {
    
    //Espacio de dibujo de cada sistema.
    pushMatrix();
      //translate(origin.x, origin.y, origin.z);
      // Dibujar sistema.
      //box(SIZE);
      run();
    popMatrix();
  }
  
  PVector getOrigin(){
    return origin;
  }
  
  color getColor(){
    return c;
  }
  
  // Determian si el origen del sistema se encuentra contenido en los límites del parámetro.
  boolean isSelected(int x, int y, int b, int h){
    int i = int(screenX(origin.x, origin.y, origin.z));
    int j = int(screenY(origin.x, origin.y, origin.z));
    if(b < 0) { x = x + b; b = -1 * b; }
    if(h < 0) { y = y + h; h = -1 * h; }
    isSelected = (x < i && i < x+b && y < j && j < y+h);
    return isSelected;
  }
  
  // Determina si el origen del sistema esta contenido dentro del volumen de colisión del viewPoint.
  boolean isPointed(){
    int x = int(screenX(origin.x, origin.y, origin.z));
    int y = int(screenY(origin.x, origin.y, origin.z));
    float dist = PVector.dist(origin,viewpoint);
    if (x > mouseX-bounds[2] && 
        x < mouseX+bounds[2] && 
        y > mouseY-bounds[5] && 
        y < mouseY+bounds[5]) {
          if(pointed){//Ya hay objeto marcado
            if(dist < p_selected_dist){
              p_selected = origin.get();
              p_selected_dist = dist;
              p_selected_2D.x = x;
              p_selected_2D.y = y;
              return true;
            } else {
              return false;
            } 
          } else {
            pointed = true;
            p_selected = origin.get();
            p_selected_dist = dist;
            p_selected_2D.x = x;
            p_selected_2D.y = y;
            return true;
          }
    } else {
      return false;
    }
  }
  
  // Metódo de comparación de sistemas
  boolean equals(ParticleSystem ps){
    PVector v = ps.getOrigin();
    return (v.x == origin.x && v.y == origin.y && v.z == origin.z);
  }
  
  // Un sistema está muerto, si no tiene partículas que actualizar.
  boolean isDead() {
    return particles.isEmpty();
  }
  
  void setOrigin(float[] v){
    origin.x = v[0];
    origin.y = v[1];
    origin.z = v[2];
    particles.remove(0);
    addParticle();
  }
  
  void moveXZ(float x, float z){
    origin.x = origin.x + x;
    origin.z = origin.z + z;
    particles.remove(0);
    addParticle();
  }
  
  void moveXYZ(float x, float y, float z){
    origin.x = origin.x + x;
    origin.y = origin.y + y;
    origin.z = origin.z + z;
    particles.remove(0);
    addParticle();
  }
  
  void setColor(color c){
    this.c = c;
  }
} /* Fin de la clase particle System*/