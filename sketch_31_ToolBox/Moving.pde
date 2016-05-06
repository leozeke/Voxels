/*
  Encapsula el comportamiento de una herramienta que pueda cambiar la posición de 
  los objetos 3D seleccionados.
*/

class Moving implements Mode{

    PVector origin = new PVector();        // Usado para obtener el origen de un objeto 3D.
    float time = 255;                      // Usado para mostrar una leyenda en pantalla.
    Label control_mov = new Label(100,100);// Leyenda.
    
    // Las matrices usadas para mover elementos.
    PMatrix3D modvw         = new PMatrix3D();
    PMatrix3D modvwInv      = new PMatrix3D();
    
    // estructuras para almacenar vectores
    float     model[]       = new float[3];
    float     point[]       = new float[3];
    
    public Moving(){
      control_mov.load("control_mov.png");
    }
    
    // Modifica el origen de cada objeto 3D
    void dibujar(ParticleSystem ps){
      
      if(ps.isSelected){
        stroke(255);
        // Obtener el origen.
        origin = ps.getOrigin();
        point[0] = origin.x;
        point[1] = origin.y;
        point[2] = origin.z;
        //Obtener el origen en coordenadas del ojo.
        modvw.mult(point,model);
        
        // Modificar el origen en el espacio del ojo.
        model[0] = model[0] + desp[0];
        model[1] = model[1] + desp[1];
        
        // Regresar el origen las coordenadas del mundo, con el ajuste a la escala.
        modvwInv.mult(model,point);
        point[0] = round(point[0] / WORLD_SCALE) * WORLD_SCALE;
        point[1] = round(point[1] / WORLD_SCALE) * WORLD_SCALE;
        point[2] = round(point[2] / WORLD_SCALE) * WORLD_SCALE;
        
        ps.setOrigin(point);
      }
    }
    
    void finish(){
        desp[0] = 0;
        desp[1] = 0;
    }
    
    // Dibuja la leyenda en pantalla.
    void drawPannel(){
      if(time > 0) {
            tint(255,time);
            time = time - 1;
            noFill();
            noStroke();
            control_mov.draw((width - control_mov.b - 10),(height - control_mov.h - 10));
            tint(255);
          }
    }
    
    
    void onWheel(MouseEvent event){}
    void onClicked(){}
    
    // Controles para la camara y el desplazamiento de los objetos.
    void onDragged(){
              if(mouseButton == LEFT){
                desp[0] = despX * (WORLD_SCALE / 4);
                desp[1] = despY * (WORLD_SCALE / 4);
              }
              if(mouseButton == RIGHT){
                O.moveAlpha(despX);
                O.moveBeta(despY);
              }
    }
    void onPressed(){}
    void onReleased(){}
    // Los objetos tambien se pueden mover con el teclado.
    void onkeyPressed(){
            switch (keyCode) {
              case UP:     {desp[1] = - WORLD_SCALE * scale; break;}
              case DOWN:   {desp[1] = WORLD_SCALE * scale; break;}
              case LEFT:   {desp[0] = - WORLD_SCALE * scale; break;}
              case RIGHT:  {desp[0] = WORLD_SCALE * scale; break;}
            }
    }
    
    void reset(){
      time = 255;
    } 
    
    // Obtiene las matrices de trsnformación actuales del objeto p3d.
    void updateMatrix(){
        //get 3d matrices
      modvw = p3d.modelview.get();
      modvwInv = p3d.modelviewInv.get();
    }

}