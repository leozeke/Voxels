/*
  La herramienat de selección marca como seleccionados todos los sistemas que 
  se encuentren dentro del área de selección.
*/

class Selecting implements Mode {
  
    int sx;          // Referencian al inicio del área de selección.
    int sy;
    
    // Inicio del área de selección.
    PVector selection_start   = new PVector();
    // Si está activa el área de selección.
    boolean selection_area     = false;
    // Si hay elementos para eliminar.
    boolean deleting = false;
    // Contador de la leyenda en pantalla.
    int time = 255;
  
  // Marca los sistemas que están seleccionados.
  void dibujar(ParticleSystem ps){
      if(selection_area){
        sx = (int)selection_start.x;
        sy = (int)selection_start.y;
        ps.isSelected(sx,sy,mouseX-sx,mouseY-sy);
      }
      if(ps.isSelected)  stroke(255);
  }
  
  void finish(){
      // Eliminación de elementos
      if(deleting){
        // El modo es selección y el usuario decidió eliminar elementos.
        for(int i = (currentLayer.system.size() - 1); i >= 0; i--){
          if(currentLayer.system.get(i).isSelected) currentLayer.system.remove(i);
        }
        deleting = false;
      }
  }
  
  // Además de dibujar la leyenda, tambien se muestra el área de selección.
  void drawPannel(){
        noStroke();
        fill(0,200,20,20);
        if(selection_area) 
          rect(selection_start.x,
                selection_start.y,
                mouseX-selection_start.x,
                mouseY-selection_start.y);
        if(time > 0) {
          tint(255,time);
          time = time - 1;
          noFill();
          noStroke();
          control_sel.draw((width - control_sel.b - 10),(height - control_sel.h - 10));
          tint(255);
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
  }
  
  // Al hacer click se guarda el inicio del área de selección.
  void onPressed(){
        if(mouseButton != RIGHT){
          selection_area = true;
          selection_start.x = mouseX;
          selection_start.y = mouseY;
        }
  }
  
  // Cuando se suelta el click, se deja de mostrar el área de selección.
  void onReleased(){
    selection_area = false;
  }
  
  // Este método escucha la ocurrencia de la tecla DELETE
  void onkeyPressed(){
    if(keyCode == 147) deleting = true;
  }
  
  // Resetear el contador
  void reset(){
    time = 255;
  }
  
  // Hay objetos para eliminar.
  void setDeletingMode(boolean mode){
    deleting = mode;
  }
}