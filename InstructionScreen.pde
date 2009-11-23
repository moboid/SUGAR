// The instruction screen explains how to play the game.

// data the instruction screen needs to load at the beginning
PFont instructionFont;
PImage instructionImage;

void setupInstructionScreen()
{
  instructionFont = sugarFont;
  instructionImage = loadImage("INSTRUCTION_BACKGROUND.jpg");
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
    background(instructionImage);
    
    text("SUGAR is for two players.  \nPlayer 1 = A key          Player 2 = L key \n \n You are a young stallion peforming the Pas de Deux. \n At each white mark you must perform a move together. \n  When your horses are both READY!, press your keys simultaneously.  \n \n CAREFUL! \n To win the crowd, you must perform your tricks together. \n Use communication to perfect your show!", width/2, height/2-150);
    
    // how to start
    text("Press any key to start the performance.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(GAMEPLAY_SCREEN);
  }
}
