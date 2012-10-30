class StringyThingy
      { 
        //set number of springs/ellipses in the line
        int numSprings = 20;
        //setup currentPoint
        Point currentPoint;
      
        Spring2D[] s = new Spring2D[numSprings];
      
      
        public StringyThingy(Point startingPoint) {
          this.currentPoint = startingPoint;
          for (int i = 0; i < numSprings; i++) {
            s[i] = new Spring2D(width / 2, i*(height / numSprings), mass, gravity);
          }
        }
      
      
        void setCurrentPoint(Point newPoint) {
          this.currentPoint = newPoint;
        }
      
        void DrawAtPoint() {
          s[0].update(currentPoint.x, currentPoint.y);
          s[0].display(currentPoint.x, currentPoint.y);
          for (int i = 1; i < numSprings; i++) {
            s[i].update(s[i-1].x, s[i-1].y);
            s[i].display(s[i-1].x, s[i-1].y);
          }
        }
      }
