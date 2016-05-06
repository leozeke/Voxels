/*
  Esta clase encapsula el comportamiento de una lista de objetos 3D
  Puedes agregarse objetos y eliminarse
*/

class Layer {

  int id;                              // Identificadr numerico.
  ArrayList<ParticleSystem> system;    // Lista de elementos 3D.
  
  private boolean exist = false;       // Si existe un elemento repetido.
  
  public Layer(){
    system = new ArrayList<ParticleSystem>();
  }

  // Varias veces necesito la lista de elementos para iterar sobre ella.
  public ArrayList<ParticleSystem> system(){
   return system;
  }
  
  // Agrega un elemento nuevo si NO está repetido.
  public void add (ParticleSystem ps){
    exist = false;
    for(int i = system.size() - 1; i >= 0 && !exist; i--){
      if(system.get(i).equals(ps)) exist = true;
    }
    if(!exist) system.add(ps);
  }
  
  // Remueve un elemento.
  public void remove(ParticleSystem p){
    system.remove(p);
  }
  
  public void setID(int id){
    this.id = id;
  }
  
  public int getID(){
    return id;
  }
}