
class CharacterMotion 
{
    float x, y;

    float jumpSpeed = 0;
    float jumpForce = 6.9f;

    float gravity = 0.25f;
    int onGravity = 0;
    boolean jumping = false;
    boolean movingLeft = false, movingRight = false;
  
    CharacterMotion(float x, float y) 
    {
        this.x = x;
        this.y = y;
    }
      
    void update() 
    {
        if (onGravity == 0) 
        {
            jumpSpeed += gravity;
            y += jumpSpeed;
        } 
        
        else if (onGravity == 1) 
        {
            jumpSpeed -= gravity;
            y += jumpSpeed;
        } 
        
        else if (onGravity == 2) 
        {
            jumpSpeed -= gravity;
            x += jumpSpeed;
        } 
        
        else if (onGravity == 3) 
        {
            jumpSpeed += gravity;
            x += jumpSpeed;
        }
        
        if (movingRight) x += 2.4;
        if (movingLeft) x -= 2.4;
        
        checkBoundaries();
    }
  
    void jump() 
    {
        jumping = true;
        if (onGravity == 0 || onGravity == 3) 
        {
            jumpSpeed = -jumpForce;
        } 
        else if (onGravity == 1 || onGravity == 2)
        {
            jumpSpeed = jumpForce;
        }
    }
  
    void startMovingLeft() { movingLeft = true; }
    void startMovingRight() { movingRight = true; }
    void stopMovingLeft() { movingLeft = false; }
    void stopMovingRight() { movingRight = false; }
  
    /* Check Boundaries */
    void checkBoundaries() 
    {
        /* Down Gravity */
        if (onGravity == 0 && y >= 580) 
        {
            y = 580;
            jumpSpeed = 0;
            jumping = false;
        }        

        /* Up Gravity */
        else if (onGravity == 1 && y <= 10) 
        {
            y = 10;
            jumpSpeed = 0;
            jumping = false;
        } 
        
        /* Left Gravity */
        else if (onGravity == 2 && x <= 10) 
        {
            x = 10;
            jumpSpeed = 0;
            jumping = false;
        }
        
        /* Right Gravity */
        else if (onGravity == 3 && x >= 1140)
        {
            x = 1140; 
            jumpSpeed = 0;
            jumping = false;
        }
    
        /* Checking Boundaries */
        
        /* Up & Down */
        if (onGravity == 0 || onGravity == 1)
        {
            if (x < -14) 
            {
                x = -14;
            }
            else if (x > width - 114) 
            {
                x = width - 114;
            }
        }
        
        /* Right & Left */
        else if (onGravity == 2 || onGravity == 3)
        {
            if (y < -14) 
            {
                y = -14;
            }
            else if (y > height - 114) 
            {
                y = height - 114;
            }
        }
    }
}
