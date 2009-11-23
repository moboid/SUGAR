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
    
    text("SUGAR is for two players.  \nPlayer 1 = A key          Player 2 = L key \n \n You are horses peforming a synchronized show. \n  Wait until both horses are READY! \n then press your keys simultaneously.  \n \n CAREFUL! \n To win the crowd, you must perform TOGETHER. \n Communicate, to perfect your show!", width/2, height/2-150);
    
    // how to start
    text("Press any key to start the performance.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(GAMEPLAY_SCREEN);
  }
}
