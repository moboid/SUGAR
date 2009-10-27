// The win screen!

PFont winFont;

void setupWinScreen()
{
  winFont = sugarFont;
}

class WinScreen extends GameScreen
{
  void enter()
  {
    textFont(winFont);
    textAlign(CENTER);
  }
  
  void draw(float dt)
  {
    background(SUGAR_BROWN);
    
    textSize(48);
    text("YOU WON!", width/2, height/2);
    
    // what next?
    textSize(24);
    text("Press any key to continue.", width/2, height/2 + 250);
  }
}
