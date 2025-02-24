class Ending 
{
    PImage end1, end2, end3;    
    float fadeAlpha = 0; 
    int Timer = 0;

    void setup() 
    {
        end1 = loadImage("Source/Image/End/end1.png");
        end2 = loadImage("Source/Image/End/end2.png");
        end3 = loadImage("Source/Image/End/end3.png");
    }
    
    void run() 
    {
        fade();
         
        image(end1, 0, 0, width, height);        

        if (Timer == 0) 
        {
            Timer = millis();  
        }          
            
        if (millis() - Timer >= 5000) 
        {
          image(end2, 0, 0, width, height);        
        }
          
        if (millis() - Timer >= 10000) 
        {
          image(end3, 0, 0, width, height);        
        }     
        
    }
     
   void fade()
   {
        if (fadeAlpha < 255) 
        {
            tint(255, fadeAlpha);
            fadeAlpha += 2; 
        } 
        else 
        {
            noTint(); 
        }
   }
 }
