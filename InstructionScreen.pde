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
    textSize(32);
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
    
    text("SUGAR is for two players.  \nPLAYER 1 = A KEY          PLAYER 2 = L KEY \n At each mark, wait for the bar to appear and press your key.  \n BUT, to succeed at the Pas de Deux you must perform at the same \n moment as your teammate, so communicate well!", width/2, height/2-75);
    
    // how to start
    text("Press any key to start the performance.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(GAMEPLAY_SCREEN);
  }
}
