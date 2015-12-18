// Esta aplicación trabaja con objetos gráficos como matrices 3D
PGraphics3D p3d;

// Para almacenar la direccion de los archivos abiertos para lectura/escritura
String path = "?";

// Los objetos se organizan en capas y hay una capa activa.
ArrayList<Layer>   layers;
Layer              currentLayer;

// La interface que respetan las herramientas del sistema.
Mode mode;
// Algunas herrmamientas y modos de trabajo.
Drawing drawing_mode       = new Drawing();
Selecting selecting_mode   = new Selecting();
PickColor pickColor_mode   = new PickColor();
Moving moving_mode         = new Moving();
Block block_mode           = new Block();

// El tamaño acotado de los bloques que forman este mundo.
int     WORLD_SCALE = 10;
float   scale = 1;                    // La escala de representación.

// Para representar la interacción del puntero y los objetos.
boolean pointed; 
float   p_selected_dist;
PVector p_selected;
PVector p_selected_2D = new PVector();
PVector p_target      = new PVector();

// Representa la cámara y los datos de la misma.
Orbital   O;
float[]   bounds = new float[6];  // Los límites inferior y superior de las cajas que encierran las partículas.
PVector   viewpoint;
float     alpha;                  // Angulo de rotación.
float     beta;                   // Angulo de elevación.

// Encapsula la selección de color, en particular se podría cambiar el estilo de selección.
ColorPicker colorPick   = new ColorPicker(115, 100);
color current_color     = color(200);       //Es el color actual con el que se crean objetos.

// Puedo parametrizar los objetos del panel de herramientas respecto de su ancho.
int pannel_width = 100;
// Los distintos objetos que ofrecen un comportamiento.
Label btn_col = new Label(80,30);
Label btn_sel = new Label(80,20);
Label btn_dra = new Label(80,20);
Label btn_mov = new Label(80,20);
Label btn_blq  = new Label(80,20);
Label btn_add = new Label(20,20);
Label btn_sub = new Label(20,20);
Label btn_up  = new Label(20,20);
Label btn_down= new Label(20,20);
Label btn_symX= new Label(30,20);
Label btn_symZ= new Label(30,20);
Label control_mov = new Label(100,100);
Label control_sel = new Label(100,100);
Label control_dra = new Label(100,100);

// Calculo el desplazamiento del mouse.
float[] desp = new float[2];
int despX = 0;
int despY = 0;

// Calculo el desplazamiento de los objetos en los ejes z, x.
float offset_z;
float offset_x;

// Calculo la intersección del rayo bajo el cursor, con el plano XZ.
float planeX = 0;
float planeZ = 0;

// Indica si se aplican los modos de simetria.
boolean symmetryX = false;
boolean symmetryZ = false;

/* ---------------------------------------------------------------------------------------------------- SETUP-- */
void setup() {
  size(800, 500, P3D);
  ortho();
  
  // Inicialización de objetos.
  p3d     = (PGraphics3D)g;
  O       = new Orbital(0,0,0);
  layers = new ArrayList<Layer>();
  currentLayer = new Layer();
  layers.add(currentLayer);
  
  // Seteo de modo inicial.
  mode = drawing_mode;
  pickColor_mode.setCP(colorPick);
  
  // Cargado de imágenes en labels que las empleen.
  control_dra.load("control_dra.png");
  control_sel.load("control_sel.png");
  control_mov.load("control_mov.png");
  btn_add.load("add.png");
  btn_sub.load("sub.png");
  btn_up.load("up.png");
  btn_down.load("down.png");
  btn_symX.load("simX.png");
  btn_symZ.load("simZ.png");
}

/* ----------------------------------------------------------------------------------------------------- DRAW-- */
void draw() {
  background(50);
  
  // Inicio del espacio de dibujo de los objetos.
  pushMatrix();
  // Actualizar datos de la cámara.
  viewpoint     = O.getPosition();
  alpha         = O.getAlpha();
  beta          = O.getBeta();
  bounds        = O.getBounds();
  // Seteo del nuevo view point
  camera(viewpoint.x,viewpoint.y,viewpoint.z,0,0,0,0,1,0);
  
  // Seteo de la escala.
  scale(scale);
  
  // Seteo de la luz
  directionalLight(200, 200, 200, 1, 1, -1);
  pointLight(200, 200, 200, viewpoint.x, viewpoint.y, viewpoint.z);
  
  // Calculo del desplazamiento actual.
  despX = mouseX - pmouseX;
  despY = mouseY - pmouseY;
  
  // La herramienta de mover, requiere de las matrices de transformación.
  if(mode == moving_mode) moving_mode.updateMatrix();
  
  // Dibujar los ejes
  drawAxes3D();
  
  // Actualizar la intersección del cursor con el plano.
  getPlanePosition();
  
  
  // Dibujar elementos dinamicos.
  pointed = false;
  
  // Capas no activas.
  noFill();                          // Objetos sin color.
  stroke(255,50);                    // Objetos con bordes translúcidos.
  for(Layer l: layers){
   if(l != currentLayer) for(ParticleSystem ps: l.system()) ps.draw();
  }
  
  // Capa activa
  for(ParticleSystem ps: currentLayer.system()){
   noStroke();
   mode.dibujar(ps);                // Aplicar efecto del modo.
   fill(ps.getColor());             // Aplicar color del objeto.                      
   ps.draw();                       // Dibujar.
  }
  mode.finish();
  
  // Fin del espacio de dibujo 3D
  popMatrix();
  
  // Espacio de dibujo 2D
  draw_toolbox();
}


/* --------------------------------------------------------------------------------------------- MOUSE EVENTS-- */

void mouseWheel(MouseEvent event) {
if(!pointInBox(mouseX,mouseY,10,10,100,10+height-20)){
    mode.onWheel(event);
  }
}
void mouseClicked() {
  if(pointInBox(mouseX,mouseY,10,10,100,10+height-20)){
      // Si el click se hizo dentro de la toolbox, se ejecuta una posible interacción.
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
        moving_mode.reset();
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
  } else mode.onClicked();    // Si el click se hizo afuera de la toolbox, se ejecuta la acción correspontiente.
}

void mouseDragged(){
  if(!pointInBox(mouseX,mouseY,10,10,100,10+height-20)){
    mode.onDragged();
  }
}
void mousePressed(){
  if(!pointInBox(mouseX,mouseY,10,10,100,10+height-20)){
    mode.onPressed();
  }
}
void mouseReleased(){
  if(!pointInBox(mouseX,mouseY,10,10,100,10+height-20)){
    mode.onReleased(); 
  }
}
void keyPressed() {
  if(!pointInBox(mouseX,mouseY,10,10,100,10+height-20)){
    mode.onkeyPressed();
  }
  if(key == 'b') mode = block_mode;
  if(key == 'g') saveSpace();
  if(key == 'o') loadSpace();
  if(key == 'q') exit();
}

/* -------------------------------------------------------------------------------------------------- 2D DRAW-- */
void draw_toolbox(){
  
  // Medidas toolbox
  int border   = pannel_width / 10;
  int y        = 0;
  int x        = border;
  int layer_h  = 2 * border; 
  int layer_limit = 0;
  int layer_fin   = height - (6 * border);
  int layer_start = layer_fin - (8 * layer_h);
  
  // Para dibujo en 2D sobre el resto de las estructuras.
  hint(DISABLE_DEPTH_TEST);
  noLights();
  
  y = y + border;                                // BOX
  stroke(255);        
  fill(#55555F);
  rect(x,y,pannel_width,height-(2*border));
  
  
  y = y + 2 * border;                            //TEXT COLOR
  fill(0);          
  text("Current Color", x + border, y);
  
  y = y + border;                                // COLOR
  strokeWeight(2);
  stroke(0);
  fill(current_color);
  btn_col.draw(x+border,y);
  
  noStroke();
  
  y = y + btn_col.getH() + 2*border;             // DRAWING
  btn_dra.setText("  DRAWING",color(200));
  fill(#37323c);
  if(mode == drawing_mode) fill(#211b22);
  btn_dra.draw(x + border,y);
  
  y = y + btn_dra.getH() + border;               // SELECTION
  fill(#37323c);
  if(mode == selecting_mode) fill(#211b22);
  btn_sel.setText("  SELECT",color(200));
  btn_sel.draw(x + border,y);
  
  y = y + btn_sel.getH() + border;               // MOVE
  fill(#37323c);
  if(mode == moving_mode) fill(#211b22);
  btn_mov.setText("  MOVE",color(200));
  btn_mov.draw(x + border,y);
  
  y = y + btn_mov.getH() + border;               // BLOCK
  fill(#37323c);
  if(mode == block_mode) fill(#211b22);
  btn_blq.setText(" BLOCK",color(200));
  btn_blq.draw(x + border,y);
  
  y = y + btn_mov.getH() + border;               // SYMMETRY
  btn_symX.draw(x + pannel_width-(btn_symX.b+btn_symZ.b+ 2 * border),y);
  if(symmetryX) {
    noStroke();
    fill(#67cf28);
    rect(x + pannel_width-(btn_symX.b+btn_symZ.b+ 2 * border)+2,y+2,4,4);
  }
  btn_symZ.draw(x + pannel_width-(btn_symX.b + border),y);
  if(symmetryZ) {
    noStroke();
    fill(#67cf28);
    rect(x + pannel_width-(btn_symX.b + border)+2,y+2,4,4);
  } 
  
  y = layer_start;                               // LAYERS
  noFill();
  stroke(200);
  strokeWeight(1);
  rect(x + border-1,y-1,pannel_width-2*border+2,layer_fin-layer_start+2);
  fill(200);
  text("  LAYERS  ",3*border, y - 5);
  // Las capas fuera del límite no se dibujan.
  layer_limit = y + 20 * (layers.size()-1);
  stroke(10);
  for(Layer l: layers){
    noFill();
    if(l == currentLayer) fill(#37323c); 
    if(layer_limit < layer_fin){ 
      rect(x + border,layer_limit,80,20);
      fill(200);
      text("Layer "+l.id,x + border+5,layer_limit+16);
    }
    layer_limit = layer_limit - 20;
  }
  
  y = height-(5*border);                        // CONTROL DE CAPAS
  noStroke();        
  fill(#55555F);
  rect(border,y,pannel_width, 4*border);
  int space = (pannel_width - (4*btn_up.b))/3;
  
  // Sumar restar capas.
  btn_add.draw(x + space, y + border);
  btn_sub.draw(x + space + btn_add.b, y + border);
  
  // Navegar entre capas.
  btn_up.draw(x + space + btn_add.b + btn_sub.b + space, y + border);
  btn_down.draw(x + space + btn_add.b + btn_sub.b + space + btn_up.b,y + border);
  
  // Dibujar elementos del modo actual.
  mode.drawPannel();
  hint(ENABLE_DEPTH_TEST);
}

// Obtener la intersección del cursor con el plano XZ.
void getPlanePosition(){
  // Creo el vector proyección de viewPoint sobre XZ.
  planeX = (mouseX - (width / 2)) / scale;
  planeZ = ((mouseY - (height / 2)) / sin(beta - (PI/2))) / scale;
  // Crear un vector en X Y para rotarlo alpha
  PVector v = new PVector(planeZ, -planeX, 0);
  v.rotate(-alpha);
  // Regresar el vector al plano XZ.
  planeX = -v.y;
  planeZ = v.x;
}

// Dibujar los 3 ejes y la cuadrícula.
void drawAxes3D() {
  
  stroke(255,0,0);
  line(0,0,0, 100,0,0);
  stroke(0,255,0);
  line(0,0,0, 0,-100,0);
  stroke(0,0,255);
  line(0,0,0, 0,0,100);
  
  stroke(255,100);
  strokeWeight(1);
  for(int l = -10; l < 10; l++){
    line(100*l,0,-1100,100*l,0,1000);
    line(-1100,0,100*l,1000,0,100*l);
  }
}

// Obtener el id que sigue para una nueva capa
int getID(){
  int i = 0;
  int id = 0;
  for(Layer l: layers){
    id = l.getID();
    if(i < id) i = id;
  }
  return i + 1;
}

// Es verdadero cuando el punto x,y se encuentra en el rectangulo delimitado por 
//    i e i+b en x
//    j y j+h en y
boolean pointInBox(float x, float y, float i, float j, float b, float h){
  return (i < x && x < i+b && j < y && y < j+h);
}

private void saveSpace(){
  selectOutput("Select a file to write to:", "saveAtfileSelected");
}

private void loadSpace(){
  selectInput("Select a file to process:", "loadAtfileSelected");
}

void loadAtfileSelected(File selection) {
  if (selection == null) {
    path = null;
  } else {
    path = selection.getAbsolutePath();
    BufferedReader reader;
    String line = "";
    reader = createReader(path);
    
    layers = new ArrayList<Layer>();
    
    String[] pieces;
    float x;
    float y;
    float z;
    float r;
    float g;
    float b;
    int ID = -1;
    
    while(line != null){
      try {
        line = reader.readLine();
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
      if(line != null){
        pieces = split(line, ' ');
        if(ID != int(pieces[0])){ layers.add(new Layer()); layers.get(layers.size()-1).setID(int(pieces[0]));}
        ID    = int(pieces[0]);
        x     = float(pieces[1]);
        y     = float(pieces[2]);
        z     = float(pieces[3]);
        r     = float(pieces[4]);
        g     = float(pieces[5]);
        b     = float(pieces[6]);
        
        layers.get(layers.size()-1).add(new ParticleSystem(new PVector(x,y,z),color(r,g,b)));
      }
    }
    currentLayer = layers.get(layers.size()-1); 
  }
}

void saveAtfileSelected(File selection) {
  if (selection == null) {
    path = null;
  } else {
    path = selection.getAbsolutePath();
    PrintWriter output;
    output = createWriter(path);
    
    // Recorrido de estructuras
    for(Layer l: layers){
      for(ParticleSystem ps: l.system){
        output.println(l.getID()+" "+ps.getOrigin().x+" "+ps.getOrigin().y+" "+ps.getOrigin().z+" "+red(ps.getColor())+" "+green(ps.getColor())+" "+blue(ps.getColor()));
      }
    }
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}