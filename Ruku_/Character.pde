/*-------------------------------------------------------------------------------------------------------------------------*/

class CharacterSet 
{
    PApplet app;
    CharacterMotion motion;
    CharacterAnimation animation;

    CharacterSet(PApplet app, float startX, float startY) 
    {
        this.app = app;
        motion = new CharacterMotion(startX, startY);
        animation = new CharacterAnimation(app);
    }
      
    void update() 
    {
        motion.update();
        animation.update(motion);
    }
  
    void display() 
    {
        animation.display(motion);
    }
  
  void handleKeyPressed(char key) 
  {
    if (key == ' ') 
    {
        if (!motion.jumping) 
        {
            motion.jump();

        }
    } 
    
    else if (key == 'a' || key == 'A') 
    {
        motion.startMovingLeft();
    } 
    
    else if (key == 'd' || key == 'D') 
    {
        motion.startMovingRight();
    }
  }
  
  void handleKeyReleased(char key) 
  {
      if (key == 'a' || key == 'A') 
      {
          motion.stopMovingLeft();
      } 
      
      else if (key == 'd' || key == 'D') 
      {
          motion.stopMovingRight();
      }
  }
}

/*-------------------------------------------------------------------------------------------------------------------------*/
