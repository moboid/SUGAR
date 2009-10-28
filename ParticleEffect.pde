// This tab contains all the stuff we need to do the sparkly particle effect thing
// when you successfully perform a trick.

import traer.physics.*;

ParticleSystem phys;
// list we'll stuff all of our pieces of confetti into.
ArrayList confettiBits;

void setupParticleEffect()
{
  phys = new ParticleSystem( 0, 0.1 );
  confettiBits = new ArrayList();
}

void updateParticleEffect(float dt)
{
  phys.tick();
  
  Iterator iter = confettiBits.iterator();
  while( iter.hasNext() )
  {
    Confetti c = (Confetti)iter.next();
    c.update(dt);
    if ( c.isDead() )
    {
      iter.remove();
    }
  }
}

void drawParticleEffect()
{
  for(int i = 0; i < confettiBits.size(); i++)
  {
    Confetti c = (Confetti)confettiBits.get(i);
    c.draw();
  }
}

void triggerParticleEffect()
{
  for(int i = 0; i < 25; i++)
  {
    for(int j = 0; j < 6; j++)
    {
      float x = random(100, width - 100);
      float y = random(100, height - 100);
      Particle p = phys.makeParticle(1.0, x, y, 0);
      float velX = random(-20, 20);
      float velY = random(-20, 20);
      p.velocity().set(velX, velY, 0);
      float lifeTime = random(1, 4);
      Confetti c = new Confetti(p, lifeTime);
      confettiBits.add(c);
    }
  }
}

// wrapper around a particle so we can manage visual state.
class Confetti
{
  Particle p;
  
  // how long my total life is.
  float totalLifeTime;
  // how long i have left to live
  float lifeTime;
  // what color of gray am I right now?
  float shade;
  
  int darkShade = 200;
  
  Confetti(Particle ip, float liveForThisLong)
  {
    p = ip;
    totalLifeTime = liveForThisLong;
    lifeTime = liveForThisLong;
    shade = random(darkShade, 255);
  }
  
  void update(float dt)
  {
    lifeTime -= dt;
    shade += 200 * dt;
    if ( shade > 255 )
    {
      shade = darkShade;
    }
    if ( isDead() )
    {
      phys.removeParticle(p);
    }
  }
  
  void draw()
  {
    noStroke();
    float a = map(lifeTime, 0, totalLifeTime, 0, 255);
    // do five ghosly bits, randomly spaced around the central position
    for(int i = 0;  i < 5; i++)
    {
      // be less transparent than the actual flying piece
      float transScale = map(i, 0, 5, 0.5, 0.1);
      fill(255, a*transScale);
      float dirStep = 2 + i*3;
      float x = p.position().x() + random(-5, 5);
      float y = p.position().y() + random(-5, 5);
      rect(x, y, 2, 2);
    }
    // draw the main bit.
    fill(shade, a);
    float sz = map(shade, darkShade, 255, 1, 3);
    rect(p.position().x(), p.position().y(), sz, sz);
  }
  
  boolean isDead()
  {
    return lifeTime <= 0;
  }
}
