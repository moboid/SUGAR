// The GameScreen class represents a particular state of the game. GameScreens, at this point anyway,
// are fully modal and only one will be active at a time. The screens for SUGAR are:
// TitleScreen, InstructionScreen, GameplayScreen, WinScreen, LoseScreen
class GameScreen
{
  // any class that extends GameScreen can override the following methods
  // to implement screen-specific funtionality.
  
  // called when a screen is first displayed
  void enter() {}
  
  // called every frame. dt is how much time, in seconds, has passed since the last frame
  void draw(float dt) {}
    
  // called when right before a screen is replaced with a new one
  void exit() {}
  
  // key events will be forward to the screen from the main program
  void keyPressed() {}
  void keyReleased() {}
}

// These are instances of each of the screens in the game.
// They can be used as arguments to SwitchScreen, when a running screen 
// wants the game to switch to a different game screen.
GameScreen TITLE_SCREEN;
GameScreen INSTRUCTION_SCREEN;
GameScreen GAMEPLAY_SCREEN;
GameScreen WIN_SCREEN;
GameScreen LOSE_SCREEN;

// the game screen we are currently displaying.
// This will have it's draw method called from the draw() function in SUGAR
GameScreen currentGameScreen;

void SwitchToScreen(GameScreen switchToScreen)
{
  // exit the current screen
  currentGameScreen.exit();
  // set the current screen to the one we want to switch to
  currentGameScreen = switchToScreen;
  // enter the new screen
  currentGameScreen.enter();
  // we don't call draw yet, that will be called in the next frame.
}
