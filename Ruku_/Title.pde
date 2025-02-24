class Start
{
    PImage backgroundImage;

    float fadeAlpha = 0;
    
    boolean startTriggered = false;
    boolean fadingOut = false;
    boolean NextStage = false;


    AudioSource audioSource;
    

    Start(PApplet app) 
    {
        audioSource = new AudioSource(app);
        backgroundImage = loadImage("Source/Image/Start/Start_.png");
    }
    
    void setup() 
    {
        textSize(32);
        fill(255);
        noStroke();
        audioSource.setup();
        audioSource.title.loop();    
    }

    void run() 
    {
        if (!startTriggered) 
        {
            displayStartScreen();
        } 
        
        else 
        {
            fadeOut();
        }
    }

    void displayStartScreen() 
    {
        image(backgroundImage, 0, 0, width, height);

        if (frameCount % 60 < 30) 
        {
            text("Press any key to start", 130, height - 100);
        }
    }

    void fadeOut() 
    {
        fill(0, fadeAlpha);
        rect(0, 0, width, height);

        if (fadeAlpha < 255) 
        {
            fadeAlpha += 5;
        }
        else 
        {
            NextStage = true; 
        }
    }

    void KeyPressed() 
    {
        if (!startTriggered) 
        {
            audioSource.title.stop();
            startTriggered = true;
            fadingOut = true;
            NextStage = true;
        }
    }
}
