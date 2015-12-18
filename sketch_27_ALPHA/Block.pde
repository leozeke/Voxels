/*
  La herramienat de blaque delimita un espacio en 3D que se rellenará  
  con elementos.
*/

class Block implements Mode {
    
    // Inicio del espacio del bloque.
    PVector ini   = new PVector();
    // fin del espacio del bloque.
    PVector fin   = new PVector();
    // Si se está en curso de generar el bloque.
    boolean block_vol     = false;
    // marca de inicio y fin
    boolean p_ini = false;
    boolean p_fin = false;
    // Contador de la leyenda en pantalla.
    int time = 255;
  
  // Marca los sistemas que están seleccionados.
  void dibujar(ParticleSystem ps){
      // Dibuja la silueta del bloque 
      if(block_vol){
        if(ps.isPointed()){
          stroke(255);
          p_fin = true;
          fin.x = ps.origin.x;
          fin.y = ps.origin.y;
          fin.z = ps.origin.z;  
        } else {
          if(!p_fin){
            fin.x = planeX;
            fin.y = 0;
            fin.z = planeZ;
          }
        }
      } else {
        if(ps.isPointed()) {
            stroke(255);
            ini.x = p_selected.x;
            ini.y = p_selected.y;
            ini.z = p_selected.z;
        }
      }
  }
  
  void finish(){
    p_ini = false;
    p_fin = false;
    if(block_vol){
      pushMatrix();
      fill(0,255,0,40);
      noStroke();
      translate((ini.x-(ini.x-fin.x)/2), (ini.y-(ini.y-fin.y)/2), (ini.z)-(ini.z-fin.z)/2);
      box(abs(fin.x-ini.x), abs(fin.y-ini.y), abs(fin.z-ini.z));
      popMatrix();
    }
  }
  
  // Además de dibujar la leyenda, tambien se muestra el área de selección.
  void drawPannel(){
        if(time > 0) {
          //tint(255,time);
          time = time - 1;
          noFill();
          noStroke();
          //control_sel.draw((width - control_sel.b - 10),(height - control_sel.h - 10));
          //tint(255);
        }
  }
  void onWheel(MouseEvent event){}
  void onClicked(){}
  
  // Control de la cámara.
  void onDragged(){
    if(mouseButton == RIGHT){
      O.moveAlpha(despX);
      O.moveBeta(despY);
    }
    if(mouseButton == LEFT){
      fin.x = planeX;
      fin.y = 0;
      fin.z = planeZ;
    }
  }
  
  // Al hacer click se guarda el inicio del área de selección.
  void onPressed(){
    block_vol = true;
    if(!pointed){
      ini.x = planeX;
      ini.y = 0;
      ini.z = planeZ;
    } else {
      //ini.x = p_selected.x;
      //ini.y = p_selected.y;
      //ini.z = p_selected.z;
    }
  }
  
  // Cuando se suelta el click, se deja de mostrar el área de selección.
  void onReleased(){
    block_vol = false;
    generate();
  }
  
  // Este método escucha la ocurrencia de la tecla DELETE
  void onkeyPressed(){
    if(keyCode == 147) mode = drawing_mode;
  }
  
  // Resetear el contador
  void reset(){
    time = 255;
  }
  
  // Genera sistemas que llenen el espacio del volumen de selección.
  private void generate(){
    
  }
}