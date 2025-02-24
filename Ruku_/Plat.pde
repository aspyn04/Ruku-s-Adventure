class Platform 
{
     float x, y, w, h;
    
     Platform(float x, float y, float w, float h) 
     {
         this.x = x;
         this.y = y;
         this.w = w;
         this.h = h;
     }
    
     void display() 
     {
         noStroke();
         fill(200);
         rect(x, y, w, h);
     }
     
     void InvisibleDisplay() 
     {
         fill(0, 100);
         rect(x, y, w, h);
     }     
     
     boolean isCollidingBottom(float px, float py, float characterHeight) 
     {
         return px > x && px < x + w && py + characterHeight >= y && py + characterHeight <= y + 5;
     }
    
     boolean isCollidingTop(float px, float py) 
     {
         return px > x && px < x + w && py <= y + h && py >= y + h - 5;
     }
}
