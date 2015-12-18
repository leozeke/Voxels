/*
  El modo de dibujo es el encargado de agregar material nuevo y de quitarlo.
  En este modo se puede dibujar a mano alzada sobre el plano XZ y sobre las 
  demás estructuras.
  
  Por otro lado tambien atiende interacciones para controlar la cámara.
*/

class Drawing implements Mode{

    // Lo uso para saber en que dirección está orientado el mundo.
    char direction;
    
    // Lo uso para leer los límites de la caja que encierra un objeto 3D.
    float[] bounds = new float[6];
    
    // Lo usi para ocultar la leyenda de uso.
    int  time = 255;
  
    void dibujar(ParticleSystem ps){
      ps.isSelected = false;              // Todas las partículas estan des-seleccionadas.
      if(ps.isPointed()) stroke(255);
      ps.moveXZ(offset_x,offset_z);       // Es posible aplicar un offset.
    }
    
    void finish(){
      offset_z = 0;
      offset_x = 0;
    }
    
    void drawPannel(){
          // Dibujo el puntero y la leyenda.
          fill(200,50,50);
          noStroke();
          ellipse(mouseX,mouseY,5,5);
          noFill();
          if(time > 0) {
            // Se atenúa con el tiempo.
            tint(255,time);
            time = time - 1;
            control_dra.draw(width - control_dra.b - 5,height - control_dra.h - 5);
            tint(255);
          }
    }
    
    void onWheel(MouseEvent event){
      // Control del zoom out/in.
      float e = event.getCount();
      O.moveRadio((int)(e*10));
      if((int)e > 0)   scale = scale + 0.1;
      else             scale = scale - 0.1;
      if(scale < 0.2) scale = 0.2; 
    }
    
    void onClicked(){
      // Gestión de elementos con el click.
      newElements();
    }
    
    void onDragged(){
      // Dibujo a mano alzada o control de la cámara.
      if (mouseButton == CENTER){
        O.moveAlpha(despX);
        O.moveBeta(despY);
      } else {
        // Si estoy por fuera de la toolBox.
        if(!(pointInBox(mouseX,mouseY,10,10,100,10+height-20)))
        newElements();
      }
    }
    
    void onPressed(){}
    void onReleased(){}
    void onkeyPressed(){
            // Control de desplazamiento del modelo
            switch (keyCode) {
              case UP:     {offset_z = - WORLD_SCALE * scale; break;}
              case DOWN:   {offset_z = WORLD_SCALE * scale; break;}
              case LEFT:   {offset_x = - WORLD_SCALE * scale; break;}
              case RIGHT:  {offset_x = WORLD_SCALE * scale; break;}
            }
    }


  // Gestionar un elemento nuevo depende del click hecho
  void newElements(){
      // Agregar
      if(mouseButton == LEFT){
        // Si el cursor no está sobre un objeto, agrego un elemento en el plano XZ
        if( !pointed ){
          // Restringir posición.
          int step = WORLD_SCALE;
          int x = (int)(planeX/step) * step;
          int z = (int)(planeZ/step) * step;
          // ADD
          currentLayer.add(new ParticleSystem(new PVector(x,0,z),current_color));
          // ADD if symmetry
          if(symmetryX) currentLayer.add(new ParticleSystem(new PVector(-x, 0, z),current_color));
          if(symmetryZ) currentLayer.add(new ParticleSystem(new PVector(x, 0, -z),current_color));
          if(symmetryZ&&symmetryX) currentLayer.add(new ParticleSystem(new PVector(-x, 0, -z),current_color));
          
        } else{
          // Si el puntero está sobre un objeto, obtengo la dirección en la que colocar objeto nuevo.
          getDirection();
          // Agrego un objeto según indica p_target.
          currentLayer.add(new ParticleSystem(new PVector(p_target.x,p_target.y,p_target.z),current_color));
          if(symmetryX) currentLayer.add(new ParticleSystem(new PVector(-p_target.x,p_target.y,p_target.z),current_color));
          if(symmetryZ) currentLayer.add(new ParticleSystem(new PVector(p_target.x,p_target.y,-p_target.z),current_color));
          if(symmetryZ&&symmetryX) currentLayer.add(new ParticleSystem(new PVector(-p_target.x,p_target.y,-p_target.z),current_color));
        }
    }
    // Eliminar
    if(mouseButton == RIGHT){
      if(pointed){
        for(ParticleSystem p: currentLayer.system()){
           if(PVector.dist(p_selected,p.getOrigin()) == 0){ 
             currentLayer.remove(p);
             break;
           }
        }
      }
    }  
}

  void reset(){
    time = 255;
  }      
      
  // Obtiene la dirección en la que apunta la cara de la caja que rodea a un objeto apuntado por el cursor.
  void getDirection(){
      
      bounds     = O.getBounds();       // Límites del volumen de colisión de un objeto.
      
      float a = bounds[0];              // ancho de la cara a la iqz.
      float b = bounds[1];              // ancho de la cara a la derecha.
      float mid = bounds[2];            // mitad en sentido horizontal.
      float c = bounds[3];              // alto de la sección superior.
      float d = bounds[4];              // alto de la sección inferior.
      float H = bounds[5];              // mitad en sentido horizontal.
    
      float x = p_selected_2D.x;        // Coordenada de selección 2D.
      float y = p_selected_2D.y;
      
      p_target.x = p_selected.x;        // Inicialización del objetivo, en el objeto actual.
      p_target.z = p_selected.z;
      p_target.y = p_selected.y;
    
    // Viendo desde arriba.
    if(beta > PI/2){
        if(x-mid < mouseX && mouseX < (x-mid)+a+b && y-H < mouseY && mouseY < (y-H)+c){
          // Si el puntero está sobre la sección superior, el nuevo objeto estárá arriba.
          p_target.y = p_selected.y - WORLD_SCALE;
        } else getFace(x,y,bounds);
        
    // Viendo desde abajo.
    } else {
      if(x-mid < mouseX && mouseX < (x-mid)+a+b && (y-H)+c < mouseY && mouseY < (y-H)+c+d){
        p_target.y = p_selected.y + WORLD_SCALE;
      } else getFace(x,y,bounds);
    }
  }
  
  // Si el puntero no apunta a la cara de arriba o a la cara de abajo, entonces determino la cara lateral.
  private void getFace(float x, float y, float[] bounds){  
    direction  = O.getDirection();    // Orientación del mundo respecto el viewPoint.
    
      float a = bounds[0];              // ancho de la cara a la iqz.
      float b = bounds[1];              // ancho de la cara a la derecha.
      float mid = bounds[2];            // mitad en sentido horizontal.
      float c = bounds[3];              // alto de la sección superior.
      float d = bounds[4];              // alto de la sección inferior.
      float H = bounds[5];              // mitad en sentido horizontal.
    
    // Si el puntero está en la sexxión inferior, debo determinar sobre qué cara.
    //if(x-mid < mouseX && mouseX < (x-mid)+a && (y-H)+c < mouseY && mouseY < (y-H)+c+d){
    if(x-mid < mouseX && mouseX < (x-mid)+a){
      //CARA de la izq
      switch(direction){
        case 'f': p_target.z = p_selected.z + WORLD_SCALE;; break;
        case 'b': p_target.z = p_selected.z - WORLD_SCALE;; break;
        case 'r': p_target.x = p_selected.x + WORLD_SCALE;; break;
        case 'l': p_target.x = p_selected.x - WORLD_SCALE;; break;
      }
    }
    if((x-mid)+a < mouseX && mouseX < (x-mid)+a+b){
      //CARA de la der
      switch(direction){
        case 'f': p_target.x = p_selected.x + WORLD_SCALE;; break;
        case 'b': p_target.x = p_selected.x - WORLD_SCALE;; break;
        case 'r': p_target.z = p_selected.z - WORLD_SCALE;; break;
        case 'l': p_target.z = p_selected.z + WORLD_SCALE;; break;
      }
    }
  }
    
}// FIN DE CLASE