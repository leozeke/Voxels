public class MenuBar{


  int X = 0;
  int Y = 0;
  int H = 20;
  int textSize = 20;
  
  String[] itemOver = new String[2];
  // El puntero está sobre el menu
  boolean over = false;
  
  int timer = 0;
  MenuItem openMenu;
  
  ArrayList<MenuItem> List;
  
  color colorBar = color(50);
  color colorOverItem = color(70);
  color colorText = color(255);
  
  public MenuBar(){
    List = new ArrayList<MenuItem>();
  }
  
  public void render(){
  
      fill(colorBar);
      noStroke();
      rect(X,Y,width,H);
    
      int index = X + 50;
      for(MenuItem M: List){
        
          M.position = index;
          
          if (mouseOverMenu(M)) {
            timer = 255;
            openMenu = M;
            fill(colorOverItem);          
          }
          else {
            fill(colorBar);
          }
          
          rect(index,Y,M.buttonLength,H);
          fill(colorText);
          textSize(textSize);
          text(M.name,index + 2, Y + H - 2);
          
          if(timer > 0){
            openMenu.render(timer);
            if(openMenu.mouseOver()) {
              timer = 255;
              over = true;
            } else{
              timer = timer - 5;
              itemOver[1] = null;
              itemOver[0] = null;
              over = false;
            } 
          }
      
          index = index + M.buttonLength;
      }
  }
  
  public void addButton(String name){
    MenuItem M = new MenuItem(name);
    List.add(M);
  }
  
  public void addItem(String menu, String item){
    for(MenuItem M: List){
      if(M.name.equals(menu)) M.addItem(item);
    }
  }
  
  public boolean mouseOverMenu(MenuItem M){
    
    boolean toRet = false;
    if(Y < mouseY && mouseY < Y + H){
      if(M.position < mouseX && mouseX < M.position + M.buttonLength){
        toRet = true;
      } 
    }    
    return toRet;
  }
  
  public String[] selection(){
    return itemOver;
  }
  
  public boolean isOver(){
    return (over || mouseY < H);
  }
  
  // CLASS
  public class MenuItem{
    
    public String name = "";
    public int buttonLength = 0;
    public int maxBoxLength = 0;
    
    public int position;
    
    public ArrayList<String> items;
    public int itemCount = 0;
    public int itemHigh = textSize + 3;
    
    public MenuItem(String name){
      this.name = name;
      textSize(textSize);
      buttonLength = int(textWidth(name) + 20);
      
      items = new ArrayList<String>();
    }
    
    public void addItem(String name){
      items.add(name);
      itemCount ++;
      textSize(textSize);
      if(textWidth(name) > maxBoxLength) maxBoxLength = int(textWidth(name)); 
    }
    
    public int boxLength(){return maxBoxLength + 10; }
    public int boxHigh(){return 6 + itemCount * itemHigh; }
    
    public boolean mouseOver(){
      boolean toRet = false;
            if(position < mouseX && mouseX < position + boxLength() && (Y + H) < mouseY && mouseY < (Y + H + boxHigh())){
              toRet = true;
            }
      return toRet;
    }
    
    public void render(int time){
      
        int line = Y + H;
        
        if(itemCount > 0){
          fill(colorBar, time);
          noStroke();
          rect(position, line, boxLength(), boxHigh());
          
          line = line + itemHigh;
          for(int i = 0; i < items.size(); i++){
            
            if(line - itemHigh < mouseY && mouseY < line){
              fill(colorOverItem);
              rect(position, line - itemHigh, boxLength(), itemHigh);
              itemOver[0] = this.name;
              itemOver[1] = items.get(i);
            }
            
            fill(colorText, time);
            text(items.get(i), position, line - 3);
            line = line + itemHigh;
          }
        }
    }
    
  } // END CLASS MenuItem
}