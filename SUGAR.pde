/** TODO: A description of this game.
  * <p>
  * <b>Credits:</b>
  * <p>
  * Design: Heather Kelley<br/>
  * Programming: Damien Di Fede<br/>
  * Art: Leonie Smelt
  * TODO: any additional credits
  */

import ddf.minim.*;
  
// a general font to be used by everyone, for now
PFont sugarFont;
// the brown color we will use for a background
//color SUGAR_BROWN = color(70, 40, 0);
PImage SUGAR_BROWN;

Minim minim;
AudioPlayer polka1;

// how many trick opportunities are in one preparation period
int PREPARE_TRICK_WINDOWS = 5;

// how long a trick window lasts.
float TRICK_WINDOW = 0.5f;

// how much the length of the trick windows for a given trick
// can vary. this is used to figure out the actual trick window
// for a horse at a marker.
float TRICK_WINDOW_VARIANCE = 0.1f;

// how much the trick window length will be scaled to be used for
// the rest window length
float REST_WINDOW_SCALE = 0.65f;

// how close together the two button presses must be for 
// two tricks to count as simultaneous
float SIMULTANEOUS_WINDOW = 0.1f;

// the slowest a horse will walk. this is units per second.
float SLOW_WALK_SPEED = 30;

// the fastest a horse will walk. this is units per second.
float FAST_WALK_SPEED = 45;
  
void setup()
{
  size(1024, 768);
  smooth();
  
  SUGAR_BROWN = loadImage("SUGAR_BACKGROUND.jpg");
  sugarFont = loadFont("BookmanOldStyle-Italic-48.vlw");
  
  minim = new Minim(this);
  polka1 = minim.loadFile("sugar_polka_01.mp3");
  
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
  //println("User pressed " + key);
  currentGameScreen.keyPressed();
}

void keyReleased()
{
  currentGameScreen.keyReleased();
}

void stop()
{
  polka1.close();
  minim.stop();
  
  super.stop();
}
