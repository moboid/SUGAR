// The instruction screen explains how to play the game.

// data the instruction screen needs to load at the beginning
PFont instructionFont;

void setupInstructionScreen()
{
  instructionFont = sugarFont;
}

class InstructionScreen extends GameScreen
{
  void enter()
  {
    textFont(instructionFont);
    textAlign(CENTER);
    textSize(24);
  }
  
  void exit()
  {
    introMusic.pause();
    introMusic.rewind();
  }
  
  void draw(float dt)
  {
    // a brown background
    background(SUGAR_BROWN);
    
    text("Put instructions here.", width/2, height/2);
    
    // how to start
    text("Press any key to play.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(GAMEPLAY_SCREEN);
  }
}
