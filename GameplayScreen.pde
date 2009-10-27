// The gameplay screen is where the game actually happens. Here we will have animated horses, input handling, and so on.

// data the gameplay screen needs to load at the beginning.
PFont gameplayFont;

void setupGameplayScreen()
{
  gameplayFont = sugarFont;
}

class GameplayScreen extends GameScreen
{
  Horse horseP1;
  Horse horseP2;
  
  GameplayScreen()
  {  
    horseP1 = new Horse();
    horseP2 = new Horse();
  }
  
  void enter()
  {
    textFont(gameplayFont);
    textAlign(CENTER);
    shapeMode(CENTER);
    
    // initial state for our horses
    horseP1.setAnimation("prance");
    horseP1.setPosition(0, height);
    horseP1.pranceTo(width/3, height/2);
    horseP1.setScale(0.3);
    
    horseP2.setAnimation("prance");
    horseP2.setAnimationSpeed(2);    
    horseP2.setPosition(width, height);
    horseP2.pranceTo(2*width/3, height/2);
    horseP2.setScale(0.3);
  }
  
  void draw(float dt)
  {
    // update the horses
    horseP1.update(dt);
    horseP2.update(dt);
    
    // draw stuff
    background(SUGAR_BROWN);
    
    textSize(24);
    text("Gameplay will happen here.", width/2, 100);
    
    // draw the horsies!
    horseP1.draw();
    horseP2.draw();
    
    // TODO go to win or lose after time is up
  }  
}

