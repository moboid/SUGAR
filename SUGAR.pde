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
AudioSnippet introMusic;
AudioPlayer polka1;
AudioSample applause;
AudioSample longApplause;
AudioSample confetti;

// how many trick opportunities are in one preparation period
int PREPARE_TRICK_WINDOWS = 6;

// how long a trick window lasts.
float TRICK_WINDOW = 1f;

// how much the length of the trick windows for a given trick
// can vary. this is used to figure out the actual trick window
// for a horse at a marker.
float TRICK_WINDOW_VARIANCE = 0.08f;

// how much the trick window length will be scaled to be used for
// the rest window length
float REST_WINDOW_SCALE = 0.60f;

// how close together the two button presses must be for 
// two tricks to count as simultaneous
float SIMULTANEOUS_WINDOW = 0.3f;

// the slowest a horse will walk. this is units per second.
float SLOW_WALK_SPEED = 32;

// the fastest a horse will walk. this is units per second.
float FAST_WALK_SPEED = 43;

// the percent chance that a horse will poop when it fails to
// simultaneously perform a trick with its partner.
float POOP_CHANCE = 1;

void setup()
{
  size(1024, 768);
  smooth();
  noCursor();

  SUGAR_BROWN = loadImage("SUGAR_BACKGROUND.jpg");
  sugarFont = loadFont("TitleFont.vlw");

  minim = new Minim(this);
  introMusic = minim.loadSnippet("sugar_intro.wav");
  polka1 = minim.loadFile("sugar_polka_01.mp3", 2048);
  longApplause = minim.loadSample("applause_orig.wav");
  applause = minim.loadSample("applause.wav");
  confetti = minim.loadSample("sugar_glitter.wav");
  confetti.setGain(-6);

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

  // setup the particle effect
  setupParticleEffect();

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

  updateParticleEffect( timeSinceLastFrame );

  drawParticleEffect();
}

void keyPressed()
{
  //println("User pressed " + key);
  currentGameScreen.keyPressed();

  if ( key == 't' )
  {
    triggerParticleEffect();
  }
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

