//This is the PlayerKey class
//class names are capitalized
//when its with a lowercase, its a variable
//the curly braces define a "scope"

class PlayerKey
{
  
//these variables are visible outside of the class
  char theKey;
  boolean isDown;
  
//thisKey is the argument to the function
//when you define a function you say what the return value is, what the name is, and comma-separated list of arguments
//this one has only one argument

//this is a constructor
//this initializes the data.  argument list.
//this confuses me
//template for an instance of an object

  PlayerKey(char keyToTrack)
  {
    theKey = keyToTrack;
    isDown = false;
  }
}
