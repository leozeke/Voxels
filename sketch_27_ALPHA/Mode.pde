/*
  La interface de Modo define un comportamiento para las posibles herramientas del sistema.
  Deben poder cambiar atributos de los sistemas de particulas.
  Deben poder responder ante eventos del mouse o del teclado.
  Deben poder interactuar de alguna forma con la interface al estar activos.
*/


interface Mode {
    
  void dibujar(ParticleSystem ps);
  void finish();
  void drawPannel();
  void onWheel(MouseEvent event);
  void onClicked();
  void onDragged();
  void onPressed();
  void onReleased();
  void onkeyPressed();
}