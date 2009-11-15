// The win screen!

PFont winFont;

void setupWinScreen()
{
  winFont = sugarFont;
}

// wraps a Tween (for y pos) and an X position
class RiserPos
{
  Tween m_tween;
  float m_startYPos;
  float m_endYPos;
  float m_XPos;
  
  RiserPos(PApplet parent, float x, float startY, float endY)
  {
    float dur = random(FASTEST_RISER, SLOWEST_RISER);
    m_tween = new Tween(parent,  dur, Tween.SECONDS, Tween.COSINE);
    m_XPos = x;
    m_startYPos = startY;
    m_endYPos = endY;
  }
  
  float x()
  {
    return m_XPos;
  }
  
  float y()
  {
    return lerp(m_startYPos, m_endYPos, m_tween.position());
  }
}

class WinScreen extends GameScreen
{
  // need a handle of the PApplet because it needs to get down to the Tween in RiserPos.
  PApplet parent;
  
  // a list of RiserPos objects that describe the position of each riser
  ArrayList risers;
  
  // the image to user for a single riser
  PImage riserImg;
  
  // the total number of risers we should create
  int    totalRisers;
  
  // timer for knowing when to spawn the next riser. counts down. in seconds.
  float  riserSpawnTimer;
  
  WinScreen(PApplet p)
  {
    parent = p;
    risers = new ArrayList();
    riserImg = loadImage("CubeRiser_02.png");
  }
  
  void enter()
  {
    textFont(winFont);
    textAlign(CENTER);
    imageMode(CENTER);
    // confetti.trigger();
    longApplause.trigger();
    risers.clear();
    totalRisers = 14;
    riserSpawnTimer = 0.5;
  }
  
  void draw(float dt)
  {
    if ( risers.size() < totalRisers )
    {
      // create a new riser maybe?
      riserSpawnTimer -= dt;
      if ( riserSpawnTimer <= 0 )
      {
        float columns = 7;
        float columnNum = risers.size()%columns;
        float rowNum = floor(risers.size()/columns);
        float shiftSize = random(155, 158);
        float x = (width - 75) - shiftSize*columnNum;
        float sy = height + riserImg.height/2;
        float targetVar = random(-10, 70);
        float ty = height - 100 - riserImg.height/2*rowNum + targetVar;
        RiserPos pos = new RiserPos(parent, x, sy, ty);
        risers.add(pos);
      }
    }
    
    background(SUGAR_BROWN);
    
    // draw all of the risers, in reverse!
    for(int i = risers.size()-1; i >= 0; i--)
    {
      RiserPos pos = (RiserPos)risers.get(i);
      image(riserImg, pos.x(), pos.y());
    }
    
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
