// The lose screen!

PFont loseFont;

    
void setupLoseScreen()
{
  loseFont = sugarFont;
}

class LoseScreen extends GameScreen
{
float delayTimer;
  void enter()
  {
    textFont(loseFont);
    textAlign(CENTER);
    delayTimer = millis();
    SMELL_MANAGER.turnSmellOff();
  }
  
  void draw(float dt)
  {
    background(SUGAR_BROWN);
    
    fill(255);
    
    textSize(48);
    text("You two need more practice! \n Try again, or let some other horses perform now.", width/2, height/2);
    
    // what next?
    textSize(24);
    text("Press a Horse button to continue.", width/2, height/2 + 250);

    // Zephlord: 
    // Check timer each frame; after 30sec, go back to title
    if (millis() - delayTimer > 30000)
      SwitchToScreen(TITLE_SCREEN);
  }
  
  void keyReleased()

  {
    if (millis() - delayTimer > 3000)
    SwitchToScreen(TITLE_SCREEN);
  }
}
