class Sun{
  int x;
  int y;
  int s;
  int col;
  
  Sun(int col){
    this.col = col;
    this.x = int(random(width));
    this.y = int(random(height));  
    this.s = 10;
  }
  
  void update(){
    if(s < 510){
      this.s += 5;    
    }
  }
  
  void display(){
    int t = int(255 - (s / 2.0));
    fill(this.col, t);
    ellipse(this.x, this.y, this.s, this.s);
  }

}
