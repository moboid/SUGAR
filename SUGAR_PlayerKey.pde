//int y = 10;
//
////two variables of type PlayerKey
//PlayerKey theAKey;
//PlayerKey theJKey;
//
////variable declaration
//PlayerKey[] theKeys;
//
//void setup() {
//  size(300,220);
//
////Here is the constructor for the class
////so these are instances of the class
////a and j are character literals.   they can be assigned to type "char"
//  theAKey = new PlayerKey('a');
//  theJKey = new PlayerKey('j');
//
////this is an array of playerKey objects  
//  theKeys = new PlayerKey[2];
//  
//  theKeys[0] = theAKey;
//  theKeys[1] = theJKey;
//
////every array has a variable called length
////i is being declared locally
////i is really standard.  might be "iterator"?
////so right now there are only 2, but i can add more above and this will still work
//  for(int i = 0; i < theKeys.length; i = i+1)
//  {
//    println("PlayerKey " + i + " is " + theKeys[i].theKey);  
//    //a handle on the PlayerKey object lets me access the variables in the class, such as "theKey"
//  }
//}
//
//void draw() 
//{
////this whole y and while thing is legacy from an example and can be gotten rid of
//  while (y < height) 
//  {
//    background(0);
//    fill(255);
//    rect(100,y,100,10);
//
//    y = y + 20;
//  }
//}
//
//void keyPressed()
//{
//  //it has to iterate through the array and check against each one
//  for(int i = 0; i < theKeys.length; i = i+1)
//  {
//    //"key" is a built-in Processing variable
//    //so if the key that's pressed is 
//    if ( key == theKeys[i].theKey )
//    {
//      println("You pressed a key I know about.");
//    }
//  }
//}
