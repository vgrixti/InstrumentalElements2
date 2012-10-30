class Particle {
  float x, y; // The x- and y-coordinates
  float vx, vy; // The x- and y-velocities
  float gravity = 0.05;
  int currentflag;
  int colour_r, colour_g, colour_b;

  Particle(int xpos, int ypos, float velx, float vely, int flag, int c_r, int c_g, int c_b) {
    x = xpos;
    y = ypos;
    vx = velx;
    vy = vely;
    currentflag = flag;
    colour_r = c_r;
    colour_g = c_g;
    colour_b = c_b;
  }

  void update() {
      vy = vy + gravity;
      y += vy;
      x += vx;
  }

  void display() {
    
    fill(colour_r, colour_g, colour_b);

    triangle(x, y, x+15, y+30, x+30, y);
    
  }
}

