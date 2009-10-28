/** TODO: A description of this game.
  * <p>
  * <b>Credits:</b>
  * <p>
  * Design: Heather Kelley<br/>
  * Programming: Damien Di Fede<br/>
  * Art: Leonie Smelt
  * TODO: any additional credits
  */
  
// a general font to be used by everyone, for now
PFont sugarFont;
// the brown color we will use for a background
//color SUGAR_BROWN = color(70, 40, 0);
PImage SUGAR_BROWN;
  
void setup()
{
  size(1024, 768);
  smooth();
  
  SUGAR_BROWN = loadImage("SUGAR_BACKGROUND.jpg");
  sugarFont = loadFont("BookmanOldStyle-Italic-48.vlw");
  
  // load all the animations
  loadAnimations();
  
  // initialize all of our game screens
  setupTitleScreen();
  TITLE_SCREEN = new TitleScreen();
  
  setupInstructionScreen();
  INSTRUCTION_SCREEN = new InstructionScreen();
  
  setupGameplayScreen();
  GAMEPLAY_SCREEN = new GameplayScreen();
  
  setupWinScreen();
  WIN_SCREEN = new WinScreen();
  
  setupLoseScreen();
  LOSE_SCREEN = new LoseScreen();
  
  // start on the title screen
  currentGameScreen = TITLE_SCREEN;
  currentGameScreen.enter();
  
  // initialize the timer we use to figure out frame dt
  lastFrameStartTime = millis();
}

int lastFrameStartTime;

// we delegate all drawing responsibilities, including the color of the background,
// to the currentGameScreen. all we do here other than that is compute the dt for 
// each frame.
void draw()
{
  // how much time has gone by since the last frame?
  float timeSinceLastFrame = millis() - lastFrameStartTime;
  // stash the start time of this frame
  lastFrameStartTime = millis();
  // convert the time to seconds
  timeSinceLastFrame /= 1000f;
  
  // println("DT: " + timeSinceLastFrame);
  
  // update the currentGameScreen
  currentGameScreen.draw( timeSinceLastFrame );
}

void keyPressed()
{
  currentGameScreen.keyPressed();
}

void keyReleased()
{
  currentGameScreen.keyReleased();
}
