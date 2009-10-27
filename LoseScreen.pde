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
    
    textSize(48);
    text("YOU LOST!", width/2, height/2);
    
    // what next?
    textSize(24);
    text("Press any key to continue.", width/2, height/2 + 250);
  }
}
