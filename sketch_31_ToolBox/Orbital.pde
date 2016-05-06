/*
  Esta clase encapsula el comportamiento de de un punto que orbita en torno
  al punto 0,0.
  Usa un istema de coordenadas esféricas para posicionarse.
  Ofrece la posibilidad de cambiar la ubicación y
  retornar la posicion en coordenadas cartesianas
*/

class Orbital{

  // Coordenadas cílindricas
  int alpha;
  int beta;
  int radio;
  
  // Origen.
  int centroX;
  int centroY;
  int centroZ;
  
  // Límites de los volumenes de colisión de los objetos.
  float[] bounds = new float[8]; // [a,b,mid,c,d,H]
  char lado = '0';
  
  public Orbital(int x, int y, int z){
    alpha = 0;
    beta = 90;
    radio = 1000;
    
    centroX = x;
    centroY = y;
    centroZ = z;
  }
  
  public void reset(){
    alpha = 0;
    beta = 90;
    radio = 1000;
  }
  
  // Cambia el valor de alpha considerando los bordes del intervalo.
  void moveAlpha(int n){
    alpha = alpha - n;
    
    if(alpha > 360) alpha = 0;
    if(alpha < 0) alpha = 360;
    setBounds();
  }
  
  // Cambia el valor de beta considerando los límites del intervalo.
  void moveBeta(int n){
    beta = beta + n;
    if(beta > 179) beta = 179;
    if(beta < 1) beta = 1;
    setBounds();
  }
  
  void moveRadio(int n){
    radio = radio + n;
    setBounds();
  }
  
  float getAlpha(){
    return (alpha * PI)/180;
  }
  
  float getBeta(){
    return (beta * PI) / 180;
  }
  
  float[] getBounds(){
    return bounds;
  }
  
  char getDirection(){
   return lado;
  }
  
  PVector getPosition(){
    
    float b = (beta * PI) / 180;
    float a = (alpha * PI)/180;
    
    float z = radio * sin(b) * cos(a);
    float x = radio * sin(b) * sin(a);
    float y = radio * cos(b);
    
    return new PVector(x+centroX,y+centroY,z+centroZ);
  }
  
  // Calcula los límites para la colisión con un objeto.
  private void setBounds(){
    float a = 0;
    float b = 0;
    float c = 0;
    float d = 0;
    
    // Angulos de alpha y beta en radianes.
    float beta = getBeta();
    float alpha = getAlpha();
    
    // Longitud de los objetos.
    float size = WORLD_SCALE*scale;
    
    // Viendo desde arriba.
    if(beta >= PI/2){
        // Calculo según el cuadrande en donde esté alpha.
        if(PI < alpha){
            if(3*PI/2 < alpha){
                a = abs((sin(alpha)  *size));
                b = (cos(alpha)      *size);
                lado = 'l';
            } else {
                a = abs((cos(alpha)   * size));
                b = abs((sin(alpha)   * size));
                lado = 'b';
            }
        } else {
            if(PI/2 < alpha){
                a = (sin(alpha)      * size);
                b = abs((cos(alpha)  * size));
                lado = 'r';
            } else {
                a = (cos(alpha)     * size);
                b = (sin(alpha)     * size);
                lado = 'f';
            }
        }
      c = abs((cos(beta)      * size));
      d = abs((sin(beta)      * size));
      bounds[0] = a;
      bounds[1] = b;
      bounds[2] = (a+b)/2;//MID
      bounds[3] = c;
      bounds[4] = d;
      bounds[5] = (c+d) / 2;//H
    // ----------------------------------------------------------------------------------
    // Desde abajo.
    } else { 
        if(PI < alpha){
            if(3*PI/2 < alpha){
                a = abs((sin(alpha)         * size));
                b = (cos(alpha)             * size);
                lado = 'l';
            } else {
                a = abs((cos(alpha)         * size));
                b = abs((sin(alpha)         * size));
                lado = 'b';
            }
        } else {
            if(PI/2 < alpha){
                a = (sin(alpha)          * size);
                b = abs((cos(alpha)      * size));
                lado = 'r';
            } else {
                a = (cos(alpha)        * size);
                b = (sin(alpha)        * size);
                lado = 'f';
            }
        }
      c = abs((sin(beta)          * size));
      d = abs((cos(beta)          * size));
      bounds[0] = a;
      bounds[1] = b;
      bounds[2] = (a+b)/2;//MID
      bounds[3] = c;
      bounds[4] = d;
      bounds[5] = (c+d) / 2;//H
    }//FIN ELSE
  }

} // FIN ORBITAL