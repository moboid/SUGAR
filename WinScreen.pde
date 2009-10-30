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
    longApplause.trigger();
  }
  
  void draw(float dt)
  {
    background(SUGAR_BROWN);
    
    fill(255);
    
    textSize(48);
    text("SPECTACULAR PERFORMANCE! \n You earned your sugar. \n  Go again, or let the next duo perform.", width/2, height/2);
    
    // what next?
    textSize(24);
    text("Press any key to continue.", width/2, height/2 + 250);
  }
  
  void keyReleased()
  {
    SwitchToScreen(TITLE_SCREEN);
  }
}
