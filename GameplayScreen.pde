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
  
  int successfulTricks;
  int tricksToWin;
  
  // marker positions are vectors whose y component is an absolute screen position
  // and whose x component is an offset from the center. the markers for horseP1
  // will offset to the left and horseP2 will offset to the right
  ArrayList markerPositions;
  
  // the marker the horses are walking to
  int       currentMarker;
  
  GameplayScreen()
  {  
    horseP1 = new Horse('a');
    horseP1.setScale(0.25);
    
    horseP2 = new Horse('j');
    horseP2.setScale(0.25);
    
    horseP1.setOtherHorse(horseP2);
    horseP2.setOtherHorse(horseP1);
    
    markerPositions = new ArrayList();
  }
  
  void enter()
  {
    textFont(gameplayFont);
    textAlign(LEFT);
    shapeMode(CORNER);
    rectMode(CENTER);
    
    markerPositions.clear();
    
    // let's generate 6 random markers. evenly spaced on y, but with some random x offsets.
    int ystart = height - 50;
    for(int i = 0; i < 6; i++)
    {
      PVector marker = new PVector( random(100, 400), ystart - i*120 );
      markerPositions.add(marker);
    }
    
    currentMarker = -1;
    
    // initial state for our horses
    horseP1.setPosition(0, height);      
    horseP2.setPosition(width, height);

    // to the first marker!
    letsGo();
    
    successfulTricks = 0;
    tricksToWin = 4;
    
    polka1.play(0);
    polka1.setGain(-6);
  }
  
  void exit()
  {
    //polka1.pause();
    polka1.shiftGain(-6, -60, 2000);
  }
  
  void draw(float dt)
  {
    // update the horses
    horseP1.update(dt);
    horseP2.update(dt);
    
    // draw stuff
    background(SUGAR_BROWN);
    
    textSize(16);
    fill(255);
    text("Tricks Performed: " + successfulTricks + " / " + tricksToWin, 10, 20);
    
    // draw the markers
    for(int i = 0; i < markerPositions.size(); i++)
    {
      PVector pos = (PVector)markerPositions.get(i);
      if ( i == currentMarker )
      {
        fill(0);
        stroke(255, 128);
      }
      else
      {
        stroke(0);
        fill(0, 128);  
      }
      float rectSize = 10;
      rect(width/2 - pos.x, pos.y, rectSize, rectSize);
      rect(width/2 + pos.x, pos.y, rectSize, rectSize);
    }
    
    // draw the horsies!
    horseP1.draw();
    horseP2.draw();
  }  
  
  void letsGo()
  {
    currentMarker++;
    
    if ( currentMarker < markerPositions.size() )
    {
      float trickPercent = random(0, 1);
      String nextTrick = "";
      if ( trickPercent < 0.3 )
      {
        nextTrick = "levade";
      }
      else if ( trickPercent < 0.6 )
      {
        nextTrick = "courbette";
      }
      else
      {
        nextTrick = "capriole";
      }
      
      PVector nextPos = (PVector)markerPositions.get(currentMarker);
      
      horseP1.pranceTo( width/2 - nextPos.x, nextPos.y, nextTrick );
      horseP2.pranceTo( width/2 + nextPos.x, nextPos.y, nextTrick );
      
    }
    else // no more markers, we're done!
    {
      if ( successfulTricks >= tricksToWin )
      {
        SwitchToScreen(WIN_SCREEN);
      }
      else
      {
        SwitchToScreen(LOSE_SCREEN);
      }
    }
    
  }
  
  void awardPoint()
  {
    successfulTricks++;
    triggerParticleEffect();
    applause.trigger();
    // confetti.trigger();
  }
  
  void keyPressed()
  {
    horseP1.keyPressed();
    horseP2.keyPressed();
  }
}

