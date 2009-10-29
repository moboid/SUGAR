// a class to represent a piece of poop.
// eventually this will probably just wrap around an AnimationInstance
// but for starts we're doing this procedurally.
class Poop
{
  private PVector m_startAt;
  private PVector m_landAt;
  private float   m_timer;
  
  Poop(PVector startAt, PVector landAt)
  {
    m_startAt = startAt;
    m_landAt = landAt;
    m_timer = 0;
  }
  
  void update(float dt)
  {
    if ( m_timer < 1 )
    {
      m_timer += dt;
    }
  }
  
  void draw()
  {
    float x = lerp(m_startAt.x, m_landAt.x, m_timer);
    float y = lerp(m_startAt.y, m_landAt.y, m_timer);
    float r = lerp(0, PI*2, m_timer);
    pushMatrix();
      translate(x, y);
      rotate(r);
      noFill();
      stroke(0);
      rect(-4, -2, 3, 5);
      rect(1, -1, 5, 4);
      rect(0, -3, 4, 5);
    popMatrix();
  }
}

