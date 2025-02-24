class CharacterAnimation 
{
    PApplet app;
    
    PImage[] idleFrames, walkRightFrames, walkLeftFrames, jumpRightFrames, jumpLeftFrames;
    int currentFrame = 0;
    int lastFrameTime = 0;
    int frameDelay = 350;
  
    CharacterAnimation(PApplet app) 
    {
        this.app = app;
    
        idleFrames = new PImage[2];
        idleFrames[0] = app.loadImage("Source/Image/Character/ruku_front1.png");
        idleFrames[1] = app.loadImage("Source/Image/Character/ruku_front2.png");
        
        walkRightFrames = new PImage[4];
        walkRightFrames[0] = app.loadImage("Source/Image/Character/ruku_walk_right1.png");
        walkRightFrames[1] = app.loadImage("Source/Image/Character/ruku_walk_right2.png");
        walkRightFrames[2] = app.loadImage("Source/Image/Character/ruku_walk_right3.png");
        walkRightFrames[3] = app.loadImage("Source/Image/Character/ruku_walk_right4.png");
        
        walkLeftFrames = new PImage[4];
        walkLeftFrames[0] = app.loadImage("Source/Image/Character/ruku_walk_left1.png");
        walkLeftFrames[1] = app.loadImage("Source/Image/Character/ruku_walk_left2.png");
        walkLeftFrames[2] = app.loadImage("Source/Image/Character/ruku_walk_left3.png");
        walkLeftFrames[3] = app.loadImage("Source/Image/Character/ruku_walk_left4.png");
        
        jumpRightFrames = new PImage[3];
        jumpRightFrames[0] = app.loadImage("Source/Image/Character/ruku_jump_right1.png");
        jumpRightFrames[1] = app.loadImage("Source/Image/Character/ruku_jump_right2.png");
        jumpRightFrames[2] = app.loadImage("Source/Image/Character/ruku_jump_right3.png");
        
        jumpLeftFrames = new PImage[3];
        jumpLeftFrames[0] = app.loadImage("Source/Image/Character/ruku_jump_left1.png");
        jumpLeftFrames[1] = app.loadImage("Source/Image/Character/ruku_jump_left2.png");
        jumpLeftFrames[2] = app.loadImage("Source/Image/Character/ruku_jump_left3.png");
    }
    
    PImage[] getCurrentFrames(CharacterMotion motion) 
    {
        if (motion.jumping) 
        {
            return motion.movingRight ? jumpRightFrames : jumpLeftFrames;
        } 
        
        else if (motion.movingRight) 
        {
            return walkRightFrames;
        } 
        
        else if (motion.movingLeft) 
        {
            return walkLeftFrames;
        }
        
        return idleFrames;
    }
    
    void update(CharacterMotion motion) 
    {
        PImage[] currentFrames = getCurrentFrames(motion);
        
        if (currentFrames != null && currentFrames.length > 0) 
        {
            int currentTime = app.millis();
            if (currentTime - lastFrameTime > frameDelay) 
            {
                currentFrame = (currentFrame + 1) % currentFrames.length;
                lastFrameTime = currentTime;
            }
        }
        
        else 
        {
            currentFrame = 0;
        }
    }
    
    void display(CharacterMotion motion) 
    {
      PImage[] frames = getCurrentFrames(motion);
      
      if (frames != null && frames.length > 0) 
      {
          int frameIndex = currentFrame % frames.length;
          
          app.pushMatrix();
    
          app.translate(motion.x + frames[frameIndex].width / 2, motion.y + frames[frameIndex].height / 2);
          
          if (motion.onGravity == 0) 
          {
              app.rotate(0);
          } 
          
          else if (motion.onGravity == 1) 
          {
              app.scale(1, -1);
          } 
          
          else if (motion.onGravity == 2) 
          {
              app.rotate(PConstants.PI / 2);
          } 
          
          else if (motion.onGravity == 3) 
          {
              app.rotate(-PConstants.PI / 2);
          }
          
          app.imageMode(PConstants.CENTER);
          app.image(frames[frameIndex], 0, 0);
          app.imageMode(PConstants.CORNER);
          app.popMatrix();
      }
    }
}
