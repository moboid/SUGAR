// These are all assets used by the TitleScreen that only need to be loaded once.
PFont titleFont;
AnimationInstance titleArt;

// load all of our assets for the title screen.
// this is called from setup() in SUGAR
void setupTitleScreen()
{
  titleFont = sugarFont;
  titleArt =  getAnimationInstance("walking");
}

// A class to do all of our TitleScreen stuff
class TitleScreen extends GameScreen
{
  float delayTimer;
  void enter()
  {
    delayTimer = millis();
    textFont(titleFont);
    textAlign(CENTER);
    shapeMode(CORNER);
    introMusic.loop();
    introMusic.setGain(-6);
    polka1.pause();
  }
  
  void draw(float dt)
  {
    // a brown background
    background(SUGAR_BROWN);
    
    fill(255);
    
    // the name of the game
    textSize(48);
    text("SUGAR", width/2, 100);
    
    // the art
      titleArt.advance(dt);
    pushMatrix();
    translate(width/2, height/2);
    scale(0.5);
    titleArt.draw();
    popMatrix();
    
    // who made it?
    textSize(32);
    text("Design: Heather Kelley", width/2, height/2 + 80);
    text("Programming: Damien Di Fede", width/2, height/2 + 120);
    text("Art: Leonie Smelt", width/2, height/2 + 160);
    
    // how to start
    text("Press any key.", width/2, height/2 + 250);
    
    // testing the timer
    // ddf: printing stuff every frame is not a very good idea once you are ready to ship.
    // println(delayTimer);
  }
  
  void keyReleased()
  {
    if (millis() - delayTimer > 1000)
//    uncomment these lines to test animations on the title screen.
//    if ( key == 'L' )
//    {
//      titleArt = getAnimationInstance("levade");
//    }
//    else if ( key == 'C' )
//    {
//      titleArt = getAnimationInstance("courbette");
//    }
//    else if ( key == 'P' )
//    {
//      titleArt = getAnimationInstance("capriole");
//    }
//    else if ( key == 'T' )
//    {
//      titleArt = getAnimationInstance("test");
//    }
//    else if ( key != CODED )
    {
      SwitchToScreen(INSTRUCTION_SCREEN);
    }
  }
}
