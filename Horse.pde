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
  
  // all the poops I am managing
  ArrayList poops;
  
  // where on the screen am I?
  private PVector m_screenPos;   
  
  // what state am I in?
  private int   m_state;
  
  // how far along m_direction we should be while moving towards 
  
  // how much we should scale before drawing.
  private float m_scale;
  // will be -1 or 1 depending on whether we should flip our x or not.
  private float m_xScale;
  
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
  
  // the counter to track how many trick windows we've had
  private int   m_trickWindowCount;
  
  // how long the trick window should be
  // the length of time between trick windows will be 90% of this value.
  private float m_trickWindow;
  
  // timer to keep track of the trick window
  private float m_trickWindowTimer;
  
  // timer to keep track of time between trick windows
  private float m_trickRestTimer;
  
  // what key on the keyboard we respond to
  private char  m_button;
  
  // ****************************
  // ** PERFORMING STATE VARIABLES
  
  // next trick to perform
  private String nextTrick;
  
  boolean performed;
  
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
    poops = new ArrayList();
    performed = false;
  }
  
  void setOtherHorse(Horse h)
  {
    m_otherHorse = h;
  }
  
  void setState(int nextState)
  {
    // disable these.
    m_trickWindowTimer = -1;
    m_trickRestTimer = -1;
    
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
        m_trickWindowCount = 0;
        // choose a trick window length
        m_trickWindow = TRICK_WINDOW + random(-TRICK_WINDOW_VARIANCE, TRICK_WINDOW_VARIANCE);
        // starting this at 0 means we'll start with a trick window
        m_trickWindowTimer = 0;
        // starting this at -1 means we won't touch it.
        m_trickRestTimer = -1;
        break;
      case PERFORMING:
        m_currentAnimation = getAnimationInstance(nextTrick);
        performed = true;
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
    
    for(int i = 0; i < poops.size(); i++)
    {
      Poop p = (Poop)poops.get(i);
      p.update(dt);
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
    // first check out the other horse
    int otherState = m_otherHorse.getState();
    // if the other horse is waiting, that means they did a trick already
    // so we should just continue on if that's the case
    if ( otherState == WAITING )
    {
      GAMEPLAY_SCREEN.letsGo();
    }
    
    // trick timer or no?
    if ( m_trickWindowTimer >= 0 )
    {
      m_trickWindowTimer += dt;
      if ( m_trickWindowTimer >= m_trickWindow )
      {
        m_trickWindowTimer = -1;
        m_trickRestTimer = 0;
        // when the trick window ends, we should see if the other horse is performing
        // if it is, that means we missed our chance for doing a simultaneous trick
        if ( otherState == PERFORMING )
        {
          setState(WAITING);
        }
      }
    }
    else if ( m_trickRestTimer >= 0 )
    {
      m_trickRestTimer += dt;
      if ( m_trickRestTimer >= m_trickWindow * REST_WINDOW_SCALE )
      {
        m_trickRestTimer = -1;
        m_trickWindowTimer = 0;
        m_trickWindowCount++;
      }
      // if we're between trick windows and the other horse is performing, we go to waiting
      if ( otherState == PERFORMING )
      {
        setState(WAITING);
      }
    }
    
    // if we're all out of windows we need to check out the other horse.
    if ( m_trickWindowCount == PREPARE_TRICK_WINDOWS )
    {
      // if they are still preparing we'll force them to bail so we can continue.
      if ( otherState == PREPARING )
      {
        GAMEPLAY_SCREEN.letsGo();        
      }
      // if they are performing, we'll wait for them to finish.
      else if ( otherState == PERFORMING )
      {
        setState(WAITING);
      }
    }
  }
  
  void keyPressed()
  {
    // only respond if we are in the correct state and in a trick window
    if ( key == m_button )
    {
      println("Horse " + m_button + " is responding.");
      if ( m_state == PREPARING && m_trickWindowTimer >= 0 )
      {
        println("Horse " + m_button + " gonna perform.");
        setState(PERFORMING);
        int otherState = m_otherHorse.getState();
        if ( otherState == PERFORMING )
        {
          float t = m_otherHorse.timeInState();
          println("Other horse has been performing for " + t + " seconds.");
          if ( t <= SIMULTANEOUS_WINDOW )
          {
            println("****** POINT!");
            GAMEPLAY_SCREEN.awardPoint();
          }
          else
          {
            println("****** NOT SIMULTANEOUS! No trick!");
            setState(WAITING);
          }
        }
      }
      else
      {
        println("Horse " + m_button + " couldn't perform because current state is " + m_state + " and the trick window timer is " + m_trickWindowTimer);
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
      // make sure we face the direction we are headed and are the correct size
      scale(m_xScale*m_scale, m_scale);
      m_currentAnimation.draw();
    popMatrix();
    
    for(int i = 0; i < poops.size(); i++)
    {
      Poop p = (Poop)poops.get(i);
      p.draw();
    }
    
    // only draw the box if we are in a trick window
    if ( m_state == PREPARING && m_trickWindowTimer >= 0 )
    {
      float timerYOff = 25;
      // timer outline
      float a = map(m_trickWindowTimer, 0, m_trickWindow, 255, 0);
      noFill();
      stroke(0, a);
      rect(m_screenPos.x, m_screenPos.y + timerYOff, 100, 10);
      
      // timer fill
      fill(0, a);
      float rectWidth = map(m_trickWindowTimer, 0, m_trickWindow, 0, 100);
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
    m_walkSpeed = random(SLOW_WALK_SPEED, FAST_WALK_SPEED);
    if ( x > m_screenPos.x )
    {
      m_xScale = -1;
    }
    else
    {
      m_xScale = 1;
    }
    
    nextTrick = trickToPerform;
    
    // transition to the walking state.
    setState(WALKING);
  }
  
  void poop()
  {
    println("Horse " + m_button + " pooped!");
    PVector startAt = new PVector(m_screenPos.x + 20*m_xScale, m_screenPos.y - 40);
    PVector landAt = new PVector(m_screenPos.x + 30*m_xScale, m_screenPos.y);
    poops.add( new Poop(startAt, landAt) );    
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
