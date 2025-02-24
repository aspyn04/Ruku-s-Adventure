class BeforeEnding 
{
    PApplet app;

    PImage End, Core_1, Core_2;

    PVector Core_1_Position, Core_2_Position;
    PVector Drag_1, Drag_2;
    PVector targetPosition1, targetPosition2;
    
    boolean draggingCore1 = false, draggingCore2 = false;
    boolean transitionTriggered = false;
    boolean NextStage = false;
    
    float phase = 0; 
    float gridSize = 20; 
    
    int Timer = 0; 

    AudioSource audioSource;

    BeforeEnding(PApplet app) 
    {
        this.app = app;
        audioSource = new AudioSource(app);

        End = loadImage("Source/Image/End/End_1.png");
        Core_1 = loadImage("Source/Image/Stage1/Core.png");
        Core_2 = loadImage("Source/Image/Stage2/Core_2.png");

        Core_1_Position = new PVector(500, 540);
        Core_2_Position = new PVector(700, 540);

        targetPosition1 = new PVector(500, 299); 
        targetPosition2 = new PVector(700, 299); 
    }

    void setup() 
    {
        audioSource.setup();
        audioSource.stage2.stop();
        audioSource.end.loop();      
    }

    void run() 
    {
        if (!transitionTriggered) 
        {
            SetBackground();   
            Flow();
            handleDragging();
        }
        
        else 
        {
            if (Timer == 0) 
            {
                Timer = millis(); 
            }          
            
            if (millis() - Timer >= 2000) 
            {
                NextStage = true;
            }
         }
      }


    void SetBackground() 
    {
        if(!transitionTriggered)
        {
          image(End, 0, 0, width, height);
  
          image(Core_1, Core_1_Position.x, Core_1_Position.y);
          image(Core_2, Core_2_Position.x, Core_2_Position.y);
  
          noFill();
          strokeWeight(1);
         
          stroke(240, 240, 240);
          rect(targetPosition1.x, targetPosition1.y, Core_1.width, Core_1.height);
        
          stroke(255, 0, 255);
          rect(targetPosition2.x, targetPosition2.y, Core_2.width, Core_2.height);
          
          
          if ((isInTargetPosition(Core_1_Position, targetPosition1, Core_1)) ||  (isInTargetPosition(Core_2_Position, targetPosition2, Core_2)))
          {
              audioSource.click.setVolume(60);
              audioSource.gravity.play();
          }              
          

          if (isInTargetPosition(Core_1_Position, targetPosition1, Core_1) && isInTargetPosition(Core_2_Position, targetPosition2, Core_2))
          {
              transitionTriggered = true;
              audioSource.correct.play();
          }     
        }

    }


    void handleDragging() 
    {
        if (draggingCore1)
        {
            Core_1_Position.x = mouseX + Drag_1.x;
            Core_1_Position.y = mouseY + Drag_1.y;
        } 
        
        else if (draggingCore2) 
        {
            Core_2_Position.x = mouseX + Drag_2.x;
            Core_2_Position.y = mouseY + Drag_2.y;
        }
    }
    
    void Flow()
    {
        for (int x = 0; x <= width; x += gridSize) 
        {
          beginShape();
          for (int y = 0; y <= 80; y += gridSize) 
          {
            float z = noise(x * 0.01, y * 0.01, phase) * 100;
            vertex(x, y - z);           
            strokeWeight(2);
            stroke(lerpColor(color(240, 240, 240), color(255, 0, 255), z / 100));
            vertex(x, y - z);
          }
          endShape();
        }
      phase += 0.04;
      
      for (int x = 0; x <= width; x += gridSize) 
      {
          beginShape();
          for (int y = height; y >= height - 80; y -= gridSize) 
          {
              float z = noise(x * 0.01, y * 0.01, phase) * 100;
              strokeWeight(2);
              stroke(lerpColor(color(240, 240, 240), color(255, 0, 255), z / 100));
              vertex(x, y + z);
          }
          endShape();
      }

      phase += 0.04;    
  }
    
    

   void MousePressed() 
    {
        if (overImage(mouseX, mouseY, Core_1_Position, Core_1)) 
        {
            draggingCore1 = true;
            Drag_1 = new PVector(Core_1_Position.x - mouseX, Core_1_Position.y - mouseY);
        } 
            
        else if (overImage(mouseX, mouseY, Core_2_Position, Core_2)) 
        {
            draggingCore2 = true;
            Drag_2 = new PVector(Core_2_Position.x - mouseX, Core_2_Position.y - mouseY);
        }
    }

    void MouseReleased() 
    {
        draggingCore1 = false;
        draggingCore2 = false;
    }

    boolean overImage(float mx, float my, PVector imagePos, PImage image) 
    {
        return mx > imagePos.x && mx < imagePos.x + image.width && my > imagePos.y && my < imagePos.y + image.height;
    }

    boolean isInTargetPosition(PVector imagePos, PVector targetPos, PImage image) 
    {
        float tolerance = 10;
        return dist(imagePos.x + image.width / 2, imagePos.y + image.height / 2, targetPos.x + image.width / 2, targetPos.y + image.height / 2) < tolerance;
    }
}
