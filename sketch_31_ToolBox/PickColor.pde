/*
  Esta herramienta despliega el panel de selección de color para establecer un nuevo color actual.
*/

class PickColor implements Mode{

  ColorPicker cp;
  color pointed_color;
  
  void setCP(ColorPicker cp){ this.cp = cp;}
  
  void dibujar(ParticleSystem ps){

          if(ps.isPointed()) pointed_color = ps.getColor();
    
          if(ps.isSelected){
            ps.setColor(colorPick.getSelectedColor());
          }
  }
  
  void finish(){}
  
  void drawPannel(){
    cp.draw();
  }
  void onWheel(MouseEvent event){}
  void onClicked(){
    if(!cp.isOver()) cp.setColor(pointed_color);
  }
  void onDragged(){}
  void onPressed(){}
  void onReleased(){}
  void onkeyPressed(){
            if(keyCode == ENTER){
              current_color = colorPick.getSelectedColor();
              mode = drawing_mode;
            }
  }
  void reset(){}
}