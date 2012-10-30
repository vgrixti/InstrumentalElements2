class GenParticle extends Particle {
  float originX, originY, resetVY;

  GenParticle(int xIn, int yIn, float vxIn, float vyIn, int stat, int cr, int cg, int cb, float ox, float oy) {
    super(xIn, yIn, vxIn, vyIn, stat, cr, cg, cb);
    originX = ox;
    originY = oy;
    resetVY = vyIn;
  }

  void regenerate() {
    if (((x > width) || (x < -30) ||
      (y > height) || (y < -30 * 1000)) && currentflag == 1) {
      x = originX;
      y = originY;
      vx = random(-1.0, 1.0);
      vy = -random(0, 10);
    }
  }

  void reset_vy() {
    if ((x > width) || (x < -30) ||
      (y > height) || (y < -30 * 1000)) {
      currentflag = 0;
      colour_r = 255;
      colour_g = 255;
      colour_b = 255;
      //vy = -random(0, 20);
      //y = originY;
      //x = originX;
    }
  }

  void flagreset() {
    currentflag = 1;
  }

  void colour_change(int ccr, int ccg, int ccb) {
    colour_r = ccr;
    colour_g = ccg;
    colour_b = ccb;
  }
}

