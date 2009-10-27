// The gameplay screen is where the game actually happens. Here we will have animated horses, input handling, and so on.

// data the gameplay screen needs to load at the beginning.
PFont gameplayFont;

void setupGameplayScreen()
{
  gameplayFont = sugarFont;
}

class GameplayScreen extends GameScreen
{
  AnimationInstance horsePrance1;
  AnimationInstance horsePrance2;
  
  GameplayScreen()
  {
    horsePrance1 = getAnimationInstance("prance");
    horsePrance2 = getAnimationInstance("prance");
    horsePrance2.setTimeScale(2);
  }
  
  void enter()
  {
    textFont(gameplayFont);
    textAlign(CENTER);
    shapeMode(CENTER);
    horsePrance1.reset();
    horsePrance2.reset();
  }
  
  void draw(float dt)
  {
    // update stuff
    horsePrance1.advance(dt);
    horsePrance2.advance(dt);
    
    // draw stuff
    background(SUGAR_BROWN);
    
    textSize(24);
    text("Gameplay will happen here.", width/2, 100);
    
    // TODO draw an animating horse in the center
    pushMatrix();
      translate(width/3, height/2);
      scale(0.5);
      horsePrance1.draw();
    popMatrix();
    
    pushMatrix();
      translate(2*width/3, height/2);
      scale(0.5);
      horsePrance2.draw();
    popMatrix();
    
    // TODO go to win or lose after time is up
  }  
}

