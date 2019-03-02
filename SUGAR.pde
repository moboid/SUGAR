

/** TODO: A description of this game.
 * <p>
 * <b>Credits:</b>
 * <p>
 * Design: Heather Kelley<br/>
 * Programming: Damien Di Fede<br/>
 * Art: Leonie Smelt
 * Additional Programming: Jacob Rosenbloom
 */

import ddf.minim.*;
import megamu.shapetween.*;
import processing.serial.*;
import processing.serial.Serial;

// a general font to be used by everyone, for now
PFont sugarFont;
// the brown color we will use for a background
//color SUGAR_BROWN = color(70, 40, 0);
PImage SUGAR_BROWN;

Minim minim;
AudioPlayer introMusic;
AudioPlayer polka1;
AudioSample applause;
AudioSample longApplause;
AudioSample confetti;

// how many trick opportunities are in one preparation period
int PREPARE_TRICK_WINDOWS = 4;
// int PREPARE_FIRST_TRICK_WINDOW = 1;

// how long a trick window lasts, in seconds.
float TRICK_WINDOW = 1f;
// float TRICK_WINDOW_FIRST = 3f;

// how much the length of the trick windows for a given trick
// can vary, in seconds. this is used to figure out the actual 
// trick window for a horse at a marker.
float TRICK_WINDOW_VARIANCE = 0.08f;

// how much the trick window length will be scaled to be used for
// the rest window length
float REST_WINDOW_SCALE = 0.40f;

// how close together the two button presses must be for 
// two tricks to count as simultaneous
float SIMULTANEOUS_WINDOW = 0.2f;

// the slowest a horse will walk. this is units per second.
float SLOW_WALK_SPEED = 40;

// the fastest a horse will walk. this is units per second.
float FAST_WALK_SPEED = 45;

// the percent chance that a horse will poop when it fails to
// simultaneously perform a trick with its partner.
float POOP_CHANCE = 1;

// the slowest a riser can rise, in seconds
float SLOWEST_RISER = 0.8;

// the fastest a riser can rise, in seconds
float FASTEST_RISER = 0.4;

// setting up the smell box
String portName;//change the 0 to a 1 or 2 etc. to match your port
Serial SMELL_PORT;

// the fail/pass conditions for the smell box
int GOOD_JOB = 0;
int BAD_SHOW = 1;


final SmellManager SMELL_MANAGER = SmellManager.getInstance(this);



void setup()
{
  size(1600, 1200);
  printArray(Serial.list());
  //portName = Serial.list()[0];
  //new Serial(this, portName, 9600);
  smooth();
  noCursor();
  // ddf: uncomment this to verify that the low-framerate "walk forever" bug has been fixed.
  //frameRate(5);

  SUGAR_BROWN = loadImage("SUGAR_BACKGROUND_1200.jpg");
  sugarFont = loadFont("TitleFont.vlw");

  minim = new Minim(this);
  introMusic = minim.loadFile("sugar_intro.wav", 2048);
  polka1 = minim.loadFile("sugar_polka_01.mp3", 2048);
  longApplause = minim.loadSample("applause_orig.wav", 2048);
  applause = minim.loadSample("applause.wav", 2048);
  confetti = minim.loadSample("sugar_glitter.wav", 2048);
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
  WIN_SCREEN = new WinScreen(this);

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
  
  if ( key == 'w' )
  {
     SwitchToScreen(WIN_SCREEN);
  }
}

void stop()
{
  polka1.close();
  minim.stop();

  super.stop();
}

static class SmellManager {
 
  private static SmellManager inst;
  private static PApplet p;
  private Serial SMELL_PORT;
  // values to write to arduino for the smells, 2 arrays of 2 vals
  // horse 1: good and bad, horse 2: good and bad
  final static char[][] writeVals = {{'A', 'B'}, {'C', 'D'}}; 
  final static char SMELL_OFF_VAL = 'O';
  final float SMELL_TIME_LIMIT = 2f;
  private static float smelledForTime;
  private static boolean smellActive;
 
  private SmellManager() {
  } 
 
  static SmellManager getInstance(PApplet papp) { 
    if (inst == null) {
      inst = new SmellManager();
      smelledForTime = 0;
      smellActive = false;
      p = papp;
    }
    return inst;
  }

  void makeSmell(int condition, int horseIndex)
  {
    SMELL_PORT.write(writeVals[horseIndex][condition]);
    println("horse"+horseIndex + " smell for condition " + condition);
    smellActive = true;
    smelledForTime = 0;
  }

  // if we are running a smell and have reached the time for smelling that, turn off the smell.
  void update(float dt)
  {
    if(smellActive)
    {
      smelledForTime += dt;
      if(smelledForTime >= SMELL_TIME_LIMIT)
      {
        SMELL_PORT.write(SMELL_OFF_VAL);
        println("smell on for " + smelledForTime +"sec, turning smell off");
        smellActive = false;
      }
    }
  }
 
  
}
