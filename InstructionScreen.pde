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
  float delayTimer;
  void enter()
  {
    delayTimer = millis();
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
    
    fill(255);
    
    text("SUGAR is for two players.  \nPlayer 1 = P1 button          Player 2 = P2 button \n \n You are horses peforming a synchronized show. \n  Wait until both horses are READY! \n then press your keys simultaneously.  \n \n CAREFUL! \n To win the crowd, you must perform TOGETHER. \n Communicate, to perfect your show!", width/2, height/2-150);
    
    // how to start
    text("Press P1 or P2 to start the performance.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    if (millis() - delayTimer > 1000)
    SwitchToScreen(GAMEPLAY_SCREEN);
  }
}
