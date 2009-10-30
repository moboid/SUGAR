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
    
    text("SUGAR is for two players.  \nPlayer 1 = A key          Player 2 = L key \n \n You are a young Lipizzaner peforming the Pas de Deux. \n At each white mark you can perform a special move. \n  While your bar fills, press your key.  \n  But that's not enough! \n To win the crowd, you must perform your tricks together. \n Use communication and quick timing to perfect your show!", width/2, height/2-150);
    
    // how to start
    text("Press any key to start the performance.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(GAMEPLAY_SCREEN);
  }
}
