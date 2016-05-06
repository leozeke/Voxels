// Libreria para volcar contenido en OBJ file
import nervoussystem.obj.*;
boolean record = false;

// Esta aplicación trabaja con objetos gráficos como matrices 3D
PGraphics3D p3d;

// Para almacenar la direccion de los archivos abiertos para lectura/escritura
String path = "?";

// El menú que muestre todas las opciones
Menu menubar;
// La caja de herramientas
ToolBox box;

// Los objetos se organizan en capas y hay una capa activa.
ArrayList<Layer>   layers;
Layer              currentLayer;

// La interface que respetan las herramientas del sistema.
Mode mode;
// Algunas herrmamientas y modos de trabajo.
Drawing drawing_mode;
Selecting selecting_mode;
PickColor pickColor_mode;
Moving moving_mode;
Block block_mode;

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

  // Medidas toolbox
  int border           = 10;
  int pannel_width     = 110;
  int pannel_height    = 500;
  int toolBox_y        = 3 * border;
  int toolBox_x        = border;
  boolean visibleToolBox = true;

// Calculo el desplazamiento del mouse.
float[] desp = new float[2];
int despX = 0;
int despY = 0;

// Calculo la intersección del rayo bajo el cursor, con el plano XZ.
float planeX = 0;
float planeZ = 0;

// Indica si se aplican los modos de simetria.
boolean symmetryX = false;
boolean symmetryZ = false;

/* ---------------------------------------------------------------------------------------------------- SETUP-- */
void setup() {
  size(900, 600, P3D);
  //fullScreen(P3D);
  surface.setResizable(true);
  ortho();
  
  // Inicialización de objetos.
  p3d     = (PGraphics3D)g;
  O       = new Orbital(0,0,0);
  layers = new ArrayList<Layer>();
  currentLayer = new Layer();
  layers.add(currentLayer);
  menubar = new Menu(this);
  box = new ToolBox();
  
  //Modos
  drawing_mode       = new Drawing();
  selecting_mode     = new Selecting();
  pickColor_mode     = new PickColor();
  moving_mode        = new Moving();
  block_mode         = new Block();
  
  // Seteo de modo inicial.
  mode = drawing_mode;
  pickColor_mode.setCP(colorPick);
}

/* ----------------------------------------------------------------------------------------------------- DRAW-- */
void draw() {
  
  background(50);
  
  // Volcado a OBJ
  if(record) {
    beginRecord("nervoussystem.obj.OBJExport", path+".obj"); 
  }
  
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
  
  // Dibujar elementos.
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
  mode.finish();                    // Funciones fuera del iterador
  
  // Fin del espacio de dibujo 3D
  popMatrix();
  
  // Fin del volcado a OBJ
  if(record) {
    endRecord();
    record = false;
  }
    
  // Espacio de dibujo 2D
  if(visibleToolBox) box.render();
  menubar.render();
}


/* --------------------------------------------------------------------------------------------- MOUSE EVENTS-- */

void mouseWheel(MouseEvent event) {
    mode.onWheel(event);
}
void mouseClicked() {
  if(!menubar.onMouseClicked()){
    if(box.mouseOver()){
        box.onMouseClicked();
    } else mode.onClicked();    // Si el click se hizo afuera de la toolbox, se ejecuta la acción correspontiente. 
  }
}
void mouseDragged(){
  if(!menubar.onMouseClicked()){
    if(box.mouseOver()){
      box.onDragged();
    } else mode.onDragged();
  }
}
void mousePressed(){
  if(!menubar.onMouseClicked()){ 
    if(box.mouseOver()){
      box.onPressed();
    } else mode.onPressed();
  }
}
void mouseReleased(){
  if(!menubar.onMouseClicked()){
    if(box.mouseOver()){
       box.onReleased();
    } else mode.onReleased();
  }
}
void keyPressed() {
  menubar.onKeyPressed(keyCode);
}

public void changeMode(Mode mode){
  this.mode = mode;
  mode.reset();
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

/* --------------------------------------------------------------------------------------------- SAVE LOAD EXPORT -- */

public void newSpace(){
  layers = new ArrayList<Layer>();
  currentLayer = new Layer();
  layers.add(currentLayer);
  path = "?";
  O.reset();
}

public void saveSpace(){
  if(path != "?") saveOnCurrentPath();
  else selectOutput("Select a file to write to:", "saveAtfileSelected");
}

public void saveSpaceAs(){
  selectOutput("Select a file to write to:", "saveAtfileSelected");
}

public void exportOBJ(){
  if(path != "?") record = true;
  else selectOutput("Select a file to write to:", "exportOBJto");
}

public void loadSpace(){
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

void exportOBJto(File selection){
  if (selection == null) {
    path = "?";
  } else {
    path = selection.getAbsolutePath();
    record = true;
  }
}

void saveAtfileSelected(File selection) {
  if (selection == null) {
    path = "?";
  } else {
    path = selection.getAbsolutePath();
    saveOnCurrentPath();
  }  
}

void saveOnCurrentPath(){
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