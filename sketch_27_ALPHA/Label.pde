/*
  La clase Label representa un sector de la interface con el que se puede 
  interactuar con clicks, muestra una imagen o un texto. 
*/

class Label {

  int x = 0;        // Punto x,y origen de la etiqueta.
  int y = 0;        
  int h    = 0;     // Ancho y alto de la etiqueta.
  int b    = 0;
  String t = "";    // Texto mostrado.
  color t_color;    // Color del texto.
  PImage img;       // Imagen asociada.
  
  // La etiqueda es creda con un alto y ancho.
  public Label(int b, int h){
    this.h = h;
    this.b = b;
  }

  // Verdadero si el punto x,y se encuentra dentro de los límites de la etiqueta.
  public boolean isOver(int xp, int yp){
    return (x < xp && xp < x+b && y < yp && yp < y+h);
  }
  
  // Retorna la altura de la etiqueta
  public int getH(){
    return h;
  }
  
  // Retorna el ancho de la etiqueta
  public int getB(){
    return b;
  }

  // Setea un texto para la etiqueta
  public void setText(String t, color c){
    this.t = t;
    t_color = c;
  }
  
  // Carga una imagen para la etiqueta.
  public void load(String s){
    // Las dimensiones de la imagen reemplazan a las dimensiones 
    // con las que es creada una etiqueta.
    img = loadImage("resources/"+s);
    h = img.height;
    b = img.width;
  }
  
  // Al dibujar en un lugar la etiqueta, se establecen los valores x,y
  public void draw(int x, int y){
    this.x = x;
    this.y = y;
    
    //Fondo
    rect(x,y,b,h);
    //Imagen
    if(img != null){image(img,x,y);}
    //Texto
    fill(t_color);
    text(t,x,y+(h/2)+6);
  }
}