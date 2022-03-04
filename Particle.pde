public class Particle {
  private PImage particle;
  private float x, y, width, height, scale, xVel, yVel;
  
  
  public Particle(PImage p, float xPos, float yPos, float w, float s, float a) { //s for scale, < 1
    particle = p; x = xPos; y = yPos; width = w; height = w; scale = s; xVel = 3*cos(a); yVel = 3*sin(a);
  }
  
  public boolean show() {
    if(width < 1 || height < 1) {
      //killParticle(this);
      return false;
    }
    width *= scale; height *= scale;
    x+=xVel; y+=yVel;
    image(particle, x, y, width, height);
    return true;
  }
}

public void addExplosion(float x, float y, float r) {
  for(int i = 0; i < 20; i++) {
    float angle = i*2*PI/20; float xPos = r*cos(angle) + x; float yPos = r*sin(angle) + y;
    PImage p = particles[(int)(Math.random()*5)];
    explosions.add(new Particle(p, xPos, yPos, 10, 0.9, angle));
  }
}

public void killParticle(Particle p) {
  if(explosions.indexOf(p) > 0)
    explosions.remove(explosions.indexOf(p));
}
