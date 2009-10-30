// The lose screen!

PFont loseFont;

void setupLoseScreen()
{
  loseFont = sugarFont;
}

class LoseScreen extends GameScreen
{
  void enter()
  {
    textFont(loseFont);
    textAlign(CENTER);
  }
  
  void draw(float dt)
  {
    background(SUGAR_BROWN);
    
    fill(255);
    
    textSize(48);
    text("You two need more practice! \n Try again, or let some other horses perform now.", width/2, height/2);
    
    // what next?
    textSize(24);
    text("Press any key to continue.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(TITLE_SCREEN);
  }
}
