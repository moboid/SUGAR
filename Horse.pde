// a class to represent the horse controlled by the player. We'll have two of these in the GameplayScreen
class Horse
{  
  private float CLOSE_ENOUGH = 2.0f;
  
  // what animation am I currently in?
  private AnimationInstance m_currentAnimation;
  
  // where on the screen am I?
  private PVector m_screenPos;
  
  // where am I going?
  private PVector m_targetPos;
  
  // direction vector pointing in the direction we should walk.
  // we'll use this to move in a straight line to our target position.
  private PVector m_walkDirection;
  // how quickly we should walk, 1 meaning 1 unit per second
  private float   m_walkSpeed;
  
  // how far along m_direction we should be while moving towards 
  
  // how much we should scale before drawing.
  private float m_scale;
  
  Horse()
  {
    m_currentAnimation = getAnimationInstance("prance");
    m_screenPos = new PVector(width/2, height/2);
    m_targetPos = new PVector(width/2, height/2);
    m_walkDirection = new PVector();
    m_scale = 1;
  }
  
  void update(float dt)
  {
    // advance our current animation
    m_currentAnimation.advance(dt);
    
    // if our current position is too far away from our target position, move towards it.
    float d = PVector.dist(m_screenPos, m_targetPos);
    if ( d > CLOSE_ENOUGH )
    {
      float xoff = m_walkDirection.x * m_walkSpeed * dt;
      float yoff = m_walkDirection.y * m_walkSpeed * dt;
      m_screenPos.x += xoff;
      m_screenPos.y += yoff;
    }    
  }
  
  void draw()
  {
    pushMatrix();
      translate(m_screenPos.x, m_screenPos.y);
      scale(m_scale);
      m_currentAnimation.draw();
    popMatrix();
  }
  
  void setAnimation(String animName)
  {
    m_currentAnimation = getAnimationInstance(animName);
  }
  
  // a timeScale of 1 is normal speed, 2 is twice as fast, etc.
  void setAnimationSpeed(float timeScale)
  {
    m_currentAnimation.setTimeScale(timeScale);
  }
  
  void pranceTo(float x, float y)
  {
    m_targetPos.set(x, y, 0);
    // figure out which way to go.
    m_walkDirection.set( x - m_screenPos.x, y - m_screenPos.y, 0 );
    m_walkDirection.normalize();
    // randomly choose a speed
    m_walkSpeed = random(15, 30);
    // prance my pretty!
    setAnimation("prance");
  }
  
  // slams the position to the indicated position
  void setPosition(float x, float y)
  {
    m_screenPos.set(x, y, 0);
    m_targetPos.set(x, y, 0);
  }
  
  void setScale(float s)
  {
    m_scale = s;
  }
}
