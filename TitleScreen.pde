// These are all assets used by the TitleScreen that only need to be loaded once.
PFont titleFont;
PShape titleArt;

// load all of our assets for the title screen.
// this is called from setup() in SUGAR
void setupTitleScreen()
{
  titleFont = sugarFont;
  titleArt =  loadShape("HORSE_PRANCE_01.svg");
}

// A class to do all of our TitleScreen stuff
class TitleScreen extends GameScreen
{
  void enter()
  {
    textFont(titleFont);
    textAlign(CENTER);
    shapeMode(CENTER);
  }
  
  void draw(float dt)
  {
    // a brown background
    background(SUGAR_BROWN);
    
    // the name of the game
    textSize(48);
    text("SUGAR", width/2, 100);
    
    // the art
    shape(titleArt, width/2, height/2 - 80, 200, 200);
    
    // who made it?
    textSize(24);
    text("Design: Heather Kelley", width/2, height/2 + 80);
    text("Programming: Damien Di Fede", width/2, height/2 + 120);
    text("Art: Leonie Smelt", width/2, height/2 + 160);
    
    // how to start
    text("Press any key.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(INSTRUCTION_SCREEN);
  }
}
