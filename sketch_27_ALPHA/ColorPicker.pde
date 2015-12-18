/*
  ColorPicker es una clase hecha para ofrecer un espacio en la interface en la que,
  con interacciones del mouse se puede seleccionar un color usando el modelo 
  natural HSB
*/

class ColorPicker{

  // Es el ancho de la sección ocupada en pantalla.
  int W = 200;
  
  // Descriptores del color 
  int hue = 0;
  int sat = W;
  int val = W;
  
  color selected_color;
    
  // Medidas de los componentes de la interface
  int startX;
  int startY;
  int longX;
  int longY;
  int finX;
  int finY;
  int bar;
  
  int hue_h;
  int sat_h;
  int val_h;
  
public ColorPicker(int x, int y){
  startX = x;
  startY = y;
  
    longX  = W;
  longY  = 100;
  
  finX = startX + longX;
  finY = startY + longY;
  
  bar = 20;
  
  hue_h = startY + 10;
  sat_h = startY + 10 + bar + 10;
  val_h = startY + 10 + 2 * (bar + 10);
}

public color getSelectedColor(){
  return selected_color;
}

public void setColor(color c){
  selected_color = c;
  colorMode(HSB, 200, 200, 200);
  hue = int(hue(c));
  sat = int(saturation(c));
  val = int(brightness(c));
  colorMode(RGB, 255, 255, 255); 
}

public boolean isOver(){
  return ( startX < mouseX && mouseX < finX + 50 
        && startY < mouseY && mouseY < finY + 60);
}

void draw(){
  
  // Dibujo de la caja contenedora.
  fill(30,40,45,50);
  rect(startX,startY,longX + 50,longY);
  
  //Cambio el modelo de color.
  colorMode(HSB, 200, 200, 200);
  
  // Dibujo de la interface.
  drawPicker();
  // Obtener interacción
  if(mousePressed){
    if(startX < mouseX && mouseX < finX && startY < mouseY && mouseY < finY){
      if(hue_h < mouseY && mouseY < hue_h + bar) hue = mouseX - startX;
      if(sat_h < mouseY && mouseY < sat_h + bar) sat = mouseX - startX;
      if(val_h < mouseY && mouseY < val_h + bar) val = mouseX - startX;
    }
  }
  
  // En base a la interacción actualizar interface.
  strokeWeight(2);
  stroke(0,0,200);
  line(hue + startX, hue_h - 2, hue + startX, hue_h + bar + 2);
  line(sat + startX, sat_h - 2, sat + startX, sat_h + bar + 2);
  line(val + startX, val_h - 2, val + startX, val_h + bar + 2);
  
  fill(0,0,200);
  text(" "+hue,finX,hue_h + bar - 2);
  text(" "+sat,finX,sat_h + bar - 2);
  text(" "+val,finX,val_h + bar - 2);
  
  int y = finY;

  selected_color = color(hue,sat,val);
  fill(selected_color);
  rect(startX+longX-60,y +10 ,60,40);
  fill(0,0,200);
  text("ENTER TO CONFIRM :)", startX,y+18);

  // Regresar al modelo de color RGB.
  colorMode(RGB, 255, 255, 255); 
}

private void drawPicker(){ 
  for(int x = 0; x < 200; x++){
    stroke(x,200,200);
    line(startX+x,hue_h,startX+x,hue_h + bar);
    stroke(hue,x,val);
    line(startX+x,sat_h,startX+x,sat_h + bar);
    stroke(0,0,x);
    line(startX+x,val_h,startX+x,val_h + bar);
  }
}
  
}