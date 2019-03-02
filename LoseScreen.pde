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
  }
  
  void keyReleased()

  {
    if (millis() - delayTimer > 3000)
    SwitchToScreen(TITLE_SCREEN);
  }
}
