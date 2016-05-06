public class Menu{

    // El objeto que funciona como menu vertical
    MenuBar menu;
    
    //Necesito una referencia a la clase principal para disparar las acciones
    sketch_31_ToolBox main;
    
    //Arreglo de teclas presionadas de forma consecutiva
    int[] keys;
    
    // Tiempo medido entre teclas presionadas
    long timer = 0;
    
  
  public Menu(sketch_31_ToolBox m){
    main = m;
    
    keys = new int[2];
    
    // Crear y agregar elementos del menu
    menu = new MenuBar();
    menu.addButton("Archivo");
    menu.addButton("Herramienta");
    menu.addButton("Ver");
    
    menu.addItem("Archivo", "Nuevo");
    menu.addItem("Archivo", "Abrir");
    menu.addItem("Archivo", "Guardar");
    menu.addItem("Archivo", "Guardar Como");
    menu.addItem("Archivo", "Exportar a OBJ");
    menu.addItem("Archivo", "Salir");
    
    menu.addItem("Herramienta", "Dibujar");
    menu.addItem("Herramienta", "Seleccionar");
    menu.addItem("Herramienta", "Mover");
    menu.addItem("Herramienta", "Generar bloque");
    
    menu.addItem("Ver", "Info");
    menu.addItem("Ver", "Tool Box");
    
  } // END Menu
  
  void render(){
    hint(DISABLE_DEPTH_TEST);
    noLights();
    menu.render();
    hint(ENABLE_DEPTH_TEST);
  }
  
  public boolean onMouseClicked() {
    String[] select = menu.selection();
    
    if(select[0] == "Archivo"){
      if(select[1] == "Nuevo"){main.newSpace();}
      if(select[1] == "Abrir"){loadSpace();}
      if(select[1] == "Guardar"){main.saveSpace();}
      if(select[1] == "Guardar Como"){saveSpaceAs();}
      if(select[1] == "Exportar a OBJ"){exportOBJ();}
      if(select[1] == "Salir"){exit();}
    }
    
    if(select[0] == "Herramienta"){
      if(select[1] == "Dibujar"){main.changeMode(main.drawing_mode);}
      if(select[1] == "Seleccionar"){main.changeMode(main.selecting_mode);}
      if(select[1] == "Mover"){main.changeMode(main.moving_mode);}
      if(select[1] == "Generar bloque"){main.changeMode(main.block_mode);}
    }
    
    if(select[0] == "Ver"){
      if(select[1] == "Info"){}
      if(select[1] == "Tool Box"){main.visibleToolBox = !main.visibleToolBox;}
    }
    
    return menu.isOver();
  }

  void onKeyPressed(int keyCode){
  
    keys[0] = keys[1];
    keys[1] = keyCode;
    
    // keyCode for control = 17
    if(keyCode == 17) timer = millis();
      
    // keyCode for 'a'     = 65
    if((timer + 500) > millis() && keys[0] == 17 && keys[1] == 65 + ('q' - 'a')){
      //println("Cntrl + q = Salir"); // Ctrl + q
      exit();
      timer = 0;
    }
    if((timer + 500) > millis() && keys[0] == 17 && keys[1] == 65 + ('s' - 'a')){
      //println("Cntrl + s = guardar"); // Ctrl + s
      main.saveSpace();
      timer = 0;
    }
    if((timer + 500) > millis() && keys[0] == 17 && keys[1] == 65 + ('n' - 'a')){
      //println("Cntrl + n = nuevo"); // Ctrl + n
      main.newSpace();
      timer = 0;
    }
    if((timer + 500) > millis() && keys[0] == 17 && keys[1] == 65 + ('o' - 'a')){
      //println("Cntrl + o = abrir"); Ctrl + o
      main.loadSpace();
      timer = 0;
    }
    if((timer + 500) > millis() && keys[0] == 17 && keys[1] == 65 + ('j' - 'a')){
      //println("Cntrl + o = abrir"); Ctrl + j
      main.exportOBJ();
      timer = 0;
    }
    
    if(keys[0] != 17 && keys[1] == 65 + ('d' - 'a')){
      // D
      main.changeMode(main.drawing_mode);
    }
    if(keys[0] != 17 && keys[1] == 65 + ('s' - 'a')){
      // s
      main.changeMode(main.selecting_mode);
    }
    if(keys[0] != 17 && keys[1] == 65 + ('c' - 'a')){
      // c
      main.changeMode(main.pickColor_mode);
    }
    if(keys[0] != 17 && keys[1] == 65 + ('m' - 'a')){
      // m
      main.changeMode(main.moving_mode);
    }
    if(keys[0] != 17 && keys[1] == 65 + ('b' - 'a')){
      // b
      main.changeMode(main.block_mode);
    }
    
    main.mode.onkeyPressed();
    
  }

}