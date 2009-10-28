// Contains all classes and so forth required for our animation system.

// all the defined animations, which we can find by name.
HashMap animations;

// loads all the animations defined in animations.xml into Animation objects
void loadAnimations()
{
  animations = new HashMap(); 
  XMLElement anims = new XMLElement(this, "animations.xml");
  int numAnims = anims.getChildCount();
  for(int i = 0; i < numAnims; i++)
  {
    XMLElement animXML = anims.getChild(i);
    //println(animXML.getName());
    if ( animXML.getName().equals("animation") )
    {
      float fps = animXML.getFloatAttribute("fps");
      String name = animXML.getStringAttribute("name");
      println("Found animation " + name);
      Animation anim = new Animation(fps);
      int numFrames = animXML.getChildCount();
      for(int f = 0; f < numFrames; f++)
      {
        XMLElement frameXML = animXML.getChild(f);
        if ( frameXML.getName().equals("frame") )
        {
          String frameFileName = frameXML.getContent();
          println("--- loading frame " + frameFileName);
          PShape frame = loadShape(frameFileName);
          anim.addFrame(frame);
        }
      }
      anim.calculateAnimationLength();
      animations.put(name, anim);
    }
  }
}

// helper function to get an instance of an animation
AnimationInstance getAnimationInstance(String animName)
{
  Animation anim = (Animation)animations.get(animName);
  return new AnimationInstance(anim);
}

// an animation stores a list of frames and the frame rate the animation should be played at.
class Animation
{
  // all of the frames of this animation
  // private because no one should be able to muck with these directly
  private ArrayList m_frames;
  // how many frames per second should this animation run at?
  private float m_fps;
  // how long is this animation, in seconds?
  private float m_animLength;
  
  Animation(float fps)
  {
    m_frames = new ArrayList();
    m_fps = fps;
  }
  
  void addFrame(PShape animFrame)
  {
    m_frames.add(animFrame);
  }
  
  void calculateAnimationLength()
  {
    m_animLength = (float)m_frames.size() / m_fps;
  }
  
  int frameCount()
  {
    return m_frames.size();
  }
  
  float length()
  {
    return m_animLength;
  }
  
  float fps()
  {
    return m_fps;
  }
  
  int frameForTime(float time)
  {
    float frameFraction = map(time, 0, m_animLength, 0, this.frameCount());
    // println("frameFraction is " + frameFraction);
    int frameNumber = floor(frameFraction) % this.frameCount();
    // println("Drawing frame " + frameNumber);
    return frameNumber;
  }
  
  void drawFrame(int frameNumber)
  {
    PShape frame = (PShape)m_frames.get(frameNumber);
    shape(frame, -frame.width/2, -frame.height);
  }
  
  // figures out which frame to draw based on the time passed in.
  void drawFrame(float atTime)
  {
    drawFrame( frameForTime(atTime) );
  }
}

// an AnimationInstance will point to a particular animation,
// but store its own state about what frame the animation should be drawing
class AnimationInstance
{
  private Animation m_animation;
  private float m_currentTime;
  private float m_timeScale;
  
  AnimationInstance(Animation anim)
  {
    m_animation = anim;
    m_currentTime = 0;
    m_timeScale = 1;
  }
  
  // resets the animation to the first frame
  void reset()
  {
    m_currentTime = 0;
  }
  
  int currentFrame()
  {
    return m_animation.frameForTime(m_currentTime);
  }
  
  void setTimeScale(float timeScale)
  {
    m_timeScale = timeScale;
  }
  
  // advance the animation by dt seconds
  // returns true if this advance caused the anim to loop
  boolean advance(float dt)
  {
    // advance our time.
    m_currentTime += dt*m_timeScale;
    if ( m_currentTime > m_animation.length() )
    {
      m_currentTime %= m_animation.length();  
      return true;
    }
    return false;
  }
  
  // display the animation frame
  void draw()
  {
    m_animation.drawFrame(m_currentTime);
  }
}
