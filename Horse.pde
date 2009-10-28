// a class to represent the horse controlled by the player. We'll have two of these in the GameplayScreen

// we only have four states and transitions are largely controlled by GameplayScreen
// so I'm not going to bother making these classes. if it gets hairy, refactoring may be in order.
static final int WAITING = 0;
static final int WALKING = 1;
static final int PREPARING = 2;
static final int PERFORMING = 3;

class Horse
{  
  // a distance that's considered close enough to a target position on screen
  // that a horse is supposed to prance towards.
  private float CLOSE_ENOUGH = 2.0f;
  
  // what animation am I currently in?
  private AnimationInstance m_currentAnimation;
  
  // where on the screen am I?
  private PVector m_screenPos;   
  
  // what state am I in?
  private int   m_state;
  
  // how far along m_direction we should be while moving towards 
  
  // how much we should scale before drawing.
  private float m_scale;
  
  // the other horse we need to synchronize with.
  private Horse m_otherHorse;
  
  // how long we have been in the current state
  private float m_stateTime;
  
  // ***************************
  // ** WALKING STATE VARIABLES
    
  // where am I going?
  private PVector m_targetPos;
  
  // how far should I move when I update my position?
  private PVector m_accumPos;
  
  // direction vector pointing in the direction we should walk.
  // we'll use this to move in a straight line to our target position.
  private PVector m_walkDirection;
  
  // how quickly we should walk, 1 meaning 1 unit per second
  private float   m_walkSpeed;
  
  // ****************************
  // ** PREPARING STATE VARIABLES
  
  // how long the preparing state can last before it "times out"
  private float PREPARE_TIME_LIMIT = 5;
  
  // the window of time we consider "simultaneous"
  private float TRICK_WINDOW = 0.3f;
  
  // what key on the keyboard we respond to
  private char  m_button;
  
  // ****************************
  // ** PERFORMING STATE VARIABLES
  
  // next trick to perform
  private String nextTrick;
  
  // *****************************
  // ** METHODS
  
  Horse(char button)
  {
    m_currentAnimation = getAnimationInstance("walking");
    m_screenPos = new PVector(width/2, height/2);
    m_targetPos = new PVector(width/2, height/2);
    m_walkDirection = new PVector();
    m_accumPos = new PVector();
    m_scale = 1;
    m_button = button;
  }
  
  void setOtherHorse(Horse h)
  {
    m_otherHorse = h;
  }
  
  void setState(int nextState)
  {
    switch(nextState)
    {
      case WAITING:
        m_currentAnimation = getAnimationInstance("waiting");
        break;
      case WALKING:
        m_currentAnimation = getAnimationInstance("walking");
        break;
      case PREPARING:
        m_currentAnimation = getAnimationInstance("preparing");
        break;
      case PERFORMING:
        m_currentAnimation = getAnimationInstance(nextTrick);
        break;
    }
    
    m_state = nextState;
    m_stateTime = 0;
  }
  
  int getState()
  {
    return m_state;
  }
  
  // how long have we been in the state we are in?
  float timeInState()
  {
    return m_stateTime;
  }
  
  void update(float dt)
  {
    m_stateTime += dt;
    
    int currFrame = m_currentAnimation.currentFrame();
    // advance our current animation
    boolean looped = m_currentAnimation.advance(dt);
    int nextFrame = m_currentAnimation.currentFrame();
    
    switch(m_state)
    {
      case WAITING:
        waitingState(dt);
        break;
      case WALKING:
        boolean updatePos = (currFrame != nextFrame);
        walkingState(dt, updatePos);
        break;
      case PREPARING:
        preparingState(dt);
        break;
      case PERFORMING:
        performingState(dt, looped);
        break;
    }
  }
  
  private void waitingState(float dt)
  {
    // we currently don't do anything special in the waitingState.
  }
  
  private void walkingState(float dt, boolean updatePosition)
  {
    // apply our accumulated movement if the animation changed frames
    if ( updatePosition )
    {
      m_screenPos.add( m_accumPos );
      // reset the accumulator
      m_accumPos.set(0, 0, 0);
      
      float d = PVector.dist(m_screenPos, m_targetPos);
      // if got there, decide what state we should transition to.
      if ( d <= CLOSE_ENOUGH )
      {
        transitionFromWalking();
      }
    }
    
    // if our current position is too far away from our target position, move towards it.
    PVector currPos = new PVector(m_screenPos.x + m_accumPos.x, m_screenPos.y + m_accumPos.y);
    float d = PVector.dist(currPos, m_targetPos);
    if ( d > CLOSE_ENOUGH )
    {
      float xoff = m_walkDirection.x * m_walkSpeed * dt;
      float yoff = m_walkDirection.y * m_walkSpeed * dt;
      m_accumPos.x += xoff;
      m_accumPos.y += yoff;
    }
  }
  
  // logic that describes how we transition out of walking
  private void transitionFromWalking()
  {
    switch( m_otherHorse.getState() )
    {
      case WAITING:
      {
        GAMEPLAY_SCREEN.letsGo();
        break;
      }
     
      case WALKING:
      {
        setState(PREPARING);
        break;
      }
      
      case PREPARING:
      {
        setState(PREPARING);
        break;
      }
      
      case PERFORMING:
      {
        setState(WAITING);
        break;
      }            
    }
  }
  
  private void preparingState(float dt)
  {
    if ( timeInState() > PREPARE_TIME_LIMIT )
    {
      int otherState = m_otherHorse.getState();
      if ( otherState == WAITING || otherState == PREPARING )
      {
        GAMEPLAY_SCREEN.letsGo();        
      }
      else if ( otherState == PERFORMING )
      {
        setState(WAITING);
      }
    }
  }
  
  void keyPressed()
  {
    if ( key == m_button )
    {
      int otherState = m_otherHorse.getState();
      if ( otherState == PREPARING )
      {
        setState(PERFORMING);
      }
      else if ( otherState == PERFORMING )
      {
        if ( m_otherHorse.timeInState() < TRICK_WINDOW )
        {
          GAMEPLAY_SCREEN.awardPoint();
          setState(PERFORMING);
        }
        else
        {
          setState(WAITING);
        }
      }
    }
  }
  
  private void performingState(float dt, boolean animFinished)
  {
    if ( animFinished )
    {
      int otherState = m_otherHorse.getState();
      if ( otherState == WAITING || otherState == PREPARING )
      {
        GAMEPLAY_SCREEN.letsGo();
      }
      else if ( otherState == PERFORMING )
      {
        setState(WAITING);
      }
    }
  }
  
  void draw()
  {
    pushMatrix();
      translate(m_screenPos.x, m_screenPos.y);
      // make sure we face the direction we are headed.
      if ( m_screenPos.x < m_targetPos.x )
      {
        scale(-1, 1);
      }
      // make sure we are the correct size
      scale(m_scale);
      m_currentAnimation.draw();
    popMatrix();
    
    if ( m_state == PREPARING )
    {
      float timerYOff = 75;
      // timer outline
      noFill();
      stroke(0);
      rect(m_screenPos.x, m_screenPos.y + timerYOff, 100, 10);
      
      // timer fill
      fill(0);
      float rectWidth = map(timeInState(), 0, PREPARE_TIME_LIMIT, 0, 100);
      rect(m_screenPos.x, m_screenPos.y + timerYOff, rectWidth, 10);
      
    }
    // TODO state specific drawing.
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
  
  void pranceTo(float x, float y, String trickToPerform)
  {
    m_targetPos.set(x, y, 0);
    // figure out which way to go.
    m_walkDirection.set( x - m_screenPos.x, y - m_screenPos.y, 0 );
    m_walkDirection.normalize();
    // randomly choose a speed
    m_walkSpeed = random(15, 25);
    
    nextTrick = trickToPerform;
    
    // transition to the walking state.
    setState(WALKING);
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
