class Transition 
{
    float phase = 0; 
    float gridSize = 20;
    float motionSpeed = 0.1;
    float fadeAlpha = 255; 

    int transitionCounter = 0; 
    int transitionDuration = 300;    
    int verticalCount = 0;
    int horizontalCount = 0; 
    
    boolean showVertical = true; 
    boolean fadingOut = true; 
    boolean transitioning = true;
    boolean fadingIn = true; 
    boolean isHorizontalNext = false; 
    boolean NextStage = false;

    AudioSource audioSource;
    

    Transition(PApplet app) 
    {
        audioSource = new AudioSource(app);
    }

    void setup() 
    {
        background(255); 
        stroke(255, 100);
        noFill();
        audioSource.setup();
        audioSource.transition.play();      
    }

    void run()
    {
        if (transitioning) 
        {
            background(255); 
            fill(0, 255 - fadeAlpha); 
            noStroke();
            rect(0, 0, width, height);

            if (fadingOut) 
            {
                fadeAlpha = max(fadeAlpha - 5, 0); 
                if (fadeAlpha == 0)
                {
                    fadingOut = false;
                    transitioning = false; 
                }
            }
            return;
        }

        background(0, 20);

        if (fadingIn) 
        {
            fadeAlpha = min(fadeAlpha + 5, 255);
        } 
        
        else
        {
            fadeAlpha = max(fadeAlpha - 5, 0);
        }

        if (fadeAlpha <= 0) 
        {
            if (showVertical) 
            {
                verticalCount++;
            }
            
            else 
            {
                horizontalCount++;
            }

            if (verticalCount >= 2 && horizontalCount >= 1) 
            {
                NextStage = true; 
                audioSource.transition.stop();
                return;
            }

            showVertical = !isHorizontalNext; 
            isHorizontalNext = !isHorizontalNext;
            fadingIn = true; 
        }
        
        else if (fadeAlpha >= 255) 
        {
            fadingIn = false;
        }

        if (showVertical) 
        {
            for (int x = 0; x <= width; x += gridSize) 
            {
                beginShape();
                for (int y = 0; y <= height; y += gridSize) 
                {
                    float z = noise(x * 0.01 + phase, y * 0.01) * 100; 

                    strokeWeight(2);
                    stroke(lerpColor(color(0, 255, 0), color(0, 255, 255), z / 100.0), fadeAlpha); 

                    vertex(x, y);
                }
                endShape();
            }
        }
        
        else 
        {
            for (int y = 0; y <= height; y += gridSize) 
            {
                beginShape();
                for (int x = 0; x <= width; x += gridSize) 
                {
                    float z = noise(x * 0.01, y * 0.01 + phase) * 100; 

                    strokeWeight(2);
                    stroke(lerpColor(color(255, 0, 255), color(138, 43, 226), z / 100.0), fadeAlpha); 

                    vertex(x, y);
                }
                endShape();
            }
        }

        phase += motionSpeed;

        transitionCounter++;
        if (transitionCounter > transitionDuration) 
        {
            transitionCounter = 0;
            fadingIn = !fadingIn; 
        }
    }
}
