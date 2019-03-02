// The instruction screen explains how to play the game.

// data the instruction screen needs to load at the beginning
PFont instructionFont;
PImage instructionImage;

void setupInstructionScreen()
{
  instructionFont = sugarFont;
  instructionImage = loadImage("INSTRUCTION_BACKGROUND_1200.jpg");
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
    
    text("SUGAR is for two players.  \nPlayer 1 = Left Horse button          Player 2 = Right Horse button \n \n You are a pair of horses peforming a synchronized show. \n  Wait until both horses are READY! \n then both press your buttons simultaneously.  \n \n CAREFUL! \n To win the crowd, you must perform TOGETHER. \n Communicate and coordinate, to perfect your show!", width/2, height/2-150);
    
    // how to start
    text("Press either Horse button to start the performance.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    if (millis() - delayTimer > 1000)
    SwitchToScreen(GAMEPLAY_SCREEN);
  }
}
