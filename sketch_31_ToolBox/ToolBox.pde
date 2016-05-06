public class ToolBox{

    // Los distintos objetos que ofrecen un comportamiento.
    Label btn_col = new Label(pannel_width - 2 * border,60);
    Label btn_sel = new Label(pannel_width - 2 * border,20);
    Label btn_dra = new Label(pannel_width - 2 * border,20);
    Label btn_mov = new Label(pannel_width - 2 * border,20);
    Label btn_blq  = new Label(pannel_width - 2 * border,20);
    Label btn_add = new Label(20,20);
    Label btn_sub = new Label(20,20);
    Label btn_up  = new Label(20,20);
    Label btn_down= new Label(20,20);
    Label btn_symX= new Label(30,20);
    Label btn_symZ= new Label(30,20);
  

    int xOffset = 0;
    int yOffset = 0;
    boolean lock = false;
  
  public ToolBox(){
    // Cargado de imágenes en labels que las empleen.
    btn_add.load("add.png");
    btn_sub.load("sub.png");
    btn_up.load("up.png");
    btn_down.load("down.png");
    btn_symX.load("simX.png");
    btn_symZ.load("simZ.png");
  }
  
  
  public void onDragged(){
    if(lock){
      toolBox_x = mouseX - xOffset;
      toolBox_y = mouseY - yOffset;
    }
    
  }
  
  public void onPressed(){
    lock = true;
    xOffset = mouseX - toolBox_x; 
    yOffset = mouseY - toolBox_y;
  }
  
  public void onReleased(){
    lock = false;
  }

  public boolean mouseOver(){
    return(toolBox_x < mouseX && mouseX < toolBox_x + pannel_width && toolBox_y < mouseY && mouseY < toolBox_y + pannel_height);
  }

  public void render(){
  
      int X = toolBox_x;
      int Y = toolBox_y;
      int layer_h          = 2 * border; 
      int layer_limit      = 0;
      int layer_fin        = Y + pannel_height - (4 * border);
      int layer_start      = layer_fin - (8 * layer_h);
      int layer_control_start = Y + pannel_height - (4 * border);
      
      // Para dibujo en 2D sobre el resto de las estructuras.
      hint(DISABLE_DEPTH_TEST);
      noLights();
      textSize(12);
      
                                                                      // BOX
      stroke(255);        
      fill(#55555F);
      rect(X,Y,pannel_width, pannel_height);
      
      
      Y = Y + 2 * border;                            //TEXT COLOR
      fill(0);          
      text("Current Color", X + border, Y);
      Y = Y + border;                                // COLOR
      strokeWeight(2);
      stroke(0);
      fill(current_color);
      btn_col.draw(X + border,Y);
      
      noStroke();
      Y = Y + btn_col.getH() + 2 * border;             // DRAWING
      btn_dra.setText("  DRAWING",color(200));
      fill(#37323c);
      if(mode == drawing_mode) fill(#211b22);
      btn_dra.draw(X + border,Y);
      
      Y = Y + btn_dra.getH() + border;               // SELECTION
      fill(#37323c);
      if(mode == selecting_mode) fill(#211b22);
      btn_sel.setText("  SELECT",color(200));
      btn_sel.draw(X + border,Y);
      
      Y = Y + btn_sel.getH() + border;               // MOVE
      fill(#37323c);
      if(mode == moving_mode) fill(#211b22);
      btn_mov.setText("  MOVE",color(200));
      btn_mov.draw(X + border,Y);
      
      Y = Y + btn_mov.getH() + border;               // BLOCK
      fill(#37323c);
      if(mode == block_mode) fill(#211b22);
      btn_blq.setText(" BLOCK",color(200));
      btn_blq.draw(X + border,Y);
      
      Y = Y + btn_mov.getH() + border;               // SYMMETRY
      btn_symX.draw(X + pannel_width-(btn_symX.b+btn_symZ.b+ 2 * border),Y);
      if(symmetryX) {
        noStroke();
        fill(#67cf28);
        rect(X + pannel_width-(btn_symX.b+btn_symZ.b+ 2 * border)+2,Y+2,4,4);
      }
      btn_symZ.draw(X + pannel_width-(btn_symX.b + border),Y);
      if(symmetryZ) {
        noStroke();
        fill(#67cf28);
        rect(X + pannel_width-(btn_symX.b + border)+2,Y+2,4,4);
      } 
      
      Y = layer_start;                               // LAYERS
      noFill();
      stroke(200);
      strokeWeight(1);
      rect(X + border-1, Y - 1, pannel_width-2 * border + 2, layer_fin - layer_start + 2);
      fill(200);
      text("  LAYERS  ", X + 2 * border, Y - 5);
      // Las capas fuera del límite no se dibujan.
      layer_limit = Y + layer_h * (layers.size()-1);
      stroke(10);
      for(Layer l: layers){
        noFill();
        if(l == currentLayer) fill(#37323c); 
        if(layer_limit < layer_fin){ 
          rect(X + border,layer_limit,pannel_width - 2 * border,layer_h);
          fill(200);
          text("Layer "+l.id,X + border+5,layer_limit+16);
        }
        layer_limit = layer_limit - 20;
      }
      
      Y = layer_control_start;                        // CONTROL DE CAPAS
      noStroke();        
      fill(#55555F);
      rect(X,Y,pannel_width, 4 * border);
      int space = (pannel_width - (4 * btn_up.b))/3;
      
      // Sumar restar capas.
      btn_add.draw(X + space, Y + border);
      btn_sub.draw(X + space + btn_add.b, Y + border);
      
      // Navegar entre capas.
      btn_up.draw(X + space + btn_add.b + btn_sub.b + space, Y + border);
      btn_down.draw(X + space + btn_add.b + btn_sub.b + space + btn_up.b,Y + border);
      
      // Dibujar elementos del modo actual.
      mode.drawPannel();
      hint(ENABLE_DEPTH_TEST);
  
  }
  
  public void onMouseClicked() {
    
    if(btn_dra.isOver(mouseX,mouseY)){
      mode = drawing_mode;
      drawing_mode.reset();
    }
    if(btn_col.isOver(mouseX,mouseY)){
      mode = pickColor_mode;
    }
    if(btn_sel.isOver(mouseX,mouseY)){
      mode = selecting_mode;
      selecting_mode.reset();
    }
    if(btn_mov.isOver(mouseX,mouseY)){
      mode = moving_mode;
      moving_mode.reset();
    }
    if(btn_blq.isOver(mouseX,mouseY)){
      mode = block_mode;
      block_mode.reset();
    }
    if(btn_add.isOver(mouseX,mouseY)){
      layers.add(new Layer());
      currentLayer = layers.get(layers.size()-1);
      currentLayer.setID(getID());
    }
    if(btn_sub.isOver(mouseX,mouseY)){
      if(layers.size()>1){
        layers.remove(currentLayer);
        currentLayer = layers.get(layers.size()-1);
      }
    }
    if(btn_down.isOver(mouseX,mouseY)){
      if(layers.size()>1){
        int i = layers.indexOf(currentLayer);
        if(i > 0) i = i - 1;
        currentLayer = layers.get(i);
      }
    }
    if(btn_up.isOver(mouseX,mouseY)){
      if(layers.size()>1){
        int i = layers.indexOf(currentLayer);
        if(i < layers.size() - 1) i = i + 1;
        currentLayer = layers.get(i);
      }
    }
    if(btn_symX.isOver(mouseX,mouseY)){
      symmetryX = !symmetryX;
    }
    if(btn_symZ.isOver(mouseX,mouseY)){
      symmetryZ = !symmetryZ;
    }
  }
  
}