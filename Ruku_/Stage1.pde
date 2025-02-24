import ddf.minim.*;

PFont boldFont, defaultFont;

class FirstStage 
{
    PApplet app; 

    /* Character */
    CharacterSet Ruku;
    
    /* Background */
    PImage Stage_1_1, Stage_1_2; 
    
    /* Item */
    Item Memo, FuseBox_1, Core;
    
    /* List */
    ArrayList<Particle> particles = new ArrayList<>();
    ArrayList<Square> squares = new ArrayList<>(); 
    ArrayList<Platform> platforms = new ArrayList<>(); 

    /* Boolean */
    boolean showSequence = false;
    
    boolean stageChanged = false;
    
    boolean particleEffect = false;
    boolean particlesActive = false;
    
    boolean NextStage = false; 
 
    boolean core = false; 
    
    boolean clear = false; 
    
    boolean startTriggered = false;
    boolean fadingOut = false;    
    
    float fadeAlpha = 0;

    /* Int */
    int textTimer = 0;
    int squareTimer = 0;
    int delayTimer = 0;
    int attempts = 5;
    int squareIndex = 0;
    
    /* Array (Color Code) */
    String[] randomColors = new String[4];
    String[] sequenceText = new String[4];
    color[] correctOrder = new color[4];
    
    PVector[] corePositions = 
    {
        new PVector(126, 60),
        new PVector(446, 30),
        new PVector(626, 120),
        new PVector(886, 40),
        new PVector(1126, 80)
    };    
    
    int lastChangeTime = 0;
    int changeInterval = 5000;  
    
    AudioSource audioSource;


    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    FirstStage(PApplet app, CharacterSet Ruku) 
    {
        this.app = app; 
        this.Ruku = Ruku;
        
        audioSource = new AudioSource(app);
    }

    void setup() 
    {
        reset();
        setComponent();
        audioSource.setup();
        audioSource.stage1.loop();
    }

    void run() 
    {
        fadeOut();
        setBack();
        displayComponent();
        Logic1();
        Logic2();
        particle(); 
    }

    void reset()
    {
        generateRandomColors();
        squares.clear();
        particles.clear();
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    /* Set Component */
    void setComponent()
    {
        Stage_1_1 = loadImage("Source/Image/Stage1/Stage_1_1.png");
        Stage_1_2 = loadImage("Source/Image/Stage1/Stage_1_2.png");

        Memo = new Item(70, 660, "Source/Image/Stage1/Memo.png");
        FuseBox_1 = new Item(200, 540, "Source/Image/Stage1/FuseBox_1.png");
        setRandomCorePosition();

    }
    
    /* Set Background */
    void setBack()
    {
        if(stageChanged)
        {
          background(Stage_1_2);
        }
        else
        {
          background(Stage_1_1);
        }
    }
    
    /* Display Component */
    void displayComponent()
    {
        // Item Display
        Memo.display();
        FuseBox_1.display();
        
        // Character 
        if(!stageChanged)
        {
            Ruku.update(); 
        }
        Ruku.display();
    }
    
    /*  Logic1(Color Code) */
    void Logic1()
    {
        /* Square Reset */
        for (Square square : squares) 
        {
            square.display();
            clear();
        }
        
        updateClearStatus();

        /* Timer */
        if (!squares.isEmpty() && !clear) 
        {
            defaultFont = createFont("SansSerif.thin", 28); 
            int timeRemaining = attempts - (int)((millis() - squareTimer) / 1000);
            if (timeRemaining >= 0)
            {
                fill(255);
                textAlign(RIGHT, TOP);
                textFont(defaultFont);

                text("Time Left: " + timeRemaining, width - 20, 20);
            }
            
            if (timeRemaining <= 2.4)
            {
                if(audioSource.ticking != null && !audioSource.ticking.isPlaying())
                {
                   audioSource.ticking.stop();
                   audioSource.ticking.play();
                }            
            }
            
            if (timeRemaining <= 0.9)
            {
                if(audioSource.changed != null && !audioSource.changed.isPlaying())
                {
                   audioSource.changed.stop();
                   audioSource.changed.play();
                }                      
            }
            
            if (timeRemaining == 0)
            {
                audioSource.ticking.stop(); 
                reset();
            }
        }
        
        /* Text */
        if (showSequence)
        {
            SequenceDisplay();
        }
    }
    
    /*  Logic2(Jump Map) */
    void Logic2()
    {
      if(stageChanged)
      {
          Core.wave();
          runJumpMap();
          if (!core)
          {
              updateCorePosition();      
          }
      }
    }

    /* Praticle */
    void particle()
    {
        if (particleEffect) 
        {
            Particles();
        }
    }
    
    /* Fade */
    void fadeOut() 
    {
        int fadeStep = 3;
        if (fadeAlpha < 255) 
        {
            tint(255, fadeAlpha); 
            image(Stage_1_1, 0, 0, width, height);
            fadeAlpha += fadeStep; 
        } 

        else 
        {
            noTint(); 
        }
    }
    /*-------------------------------------------------------------------------------------------------------------------------*/

    class Square 
    {
        float x, y;
        color[] colors = {color(255, 0, 0), color(0, 255, 0), color(255, 255, 0), color(0, 0, 255)};
        int clickCount = 0;

        Square(float x, float y) 
        {
            this.x = x;
            this.y = y;
        }

        void display() 
        {
            fill(colors[clickCount % colors.length]);
            noStroke();
            rect(x, y, 100, 100);
        }

        void nextColor() 
        {
            clickCount++;
        }
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/

    void generateRandomColors() 
    {
        String[] possibleColors = {"red", "green", "yellow", "blue"};
        color[] colorValues = {color(255, 0, 0), color(0, 255, 0), color(255, 255, 0), color(0, 0, 255)};

        for (int i = 0; i < randomColors.length; i++) 
        {
            int randomIndex = int(random(possibleColors.length));
            sequenceText[i] = possibleColors[randomIndex];
            correctOrder[i] = colorValues[randomIndex];
        }
    }

    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    boolean checkSquaresCompleted() 
    {
        for (int i = 0; i < squares.size(); i++) 
        {
            Square square = squares.get(i);
            if (square.colors[square.clickCount % square.colors.length] != correctOrder[i]) 
            {
                return false;
            }
        }
        return true;
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    void SequenceDisplay() 
    {
        drawTextWithBackground(sequenceText);
        if (millis() - textTimer > 1500) 
        {
            if (showSequence) 
            { 
                showSequence = false;
                if (audioSource.crumple != null) 
                {
                    audioSource.crumple.stop();
                    audioSource.crumple.play();
                }
            }
        }
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/

    void drawTextWithBackground(String[] texts) 
    {
        if (texts == null || texts.length == 0) return;
        
        boldFont = createFont("SansSerif.bold", 32); 
        
        textAlign(CENTER, CENTER);
        fill(104, 96, 86);
        strokeWeight(1);
        stroke(255);
        float rectWidth = 450;
        float rectHeight = 500;
        rect(width / 2 - rectWidth / 2, height / 2 - rectHeight / 2, rectWidth, rectHeight, 4);
        float spacing = 80;
        float textStartY = height / 2 - ((texts.length - 0.5f) * spacing) / 2;

        
        /* Title (Color Code) */
        fill(255); 
        textFont(boldFont);
        text("Color Code", width / 2, height / 2 - rectHeight / 2 + 80);
       
        for (int i = 0; i < texts.length; i++) 
        {
            if (texts[i].equals("red")) fill(255, 0, 0);
            else if (texts[i].equals("green")) fill(0, 255, 0);
            else if (texts[i].equals("yellow")) fill(255, 255, 0);
            else if (texts[i].equals("blue")) fill(0, 0, 255);
            else fill(255);
            text(texts[i], width / 2, textStartY + 55 + i * spacing);
        }
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/

    void Particles() 
    {
        if (particles.isEmpty()) 
        {
            for (int i = 0; i < 200; i++) 
            { 
                particles.add(new Particle(Core.x, Core.y)); 
            }
        }
    
        for (int i = particles.size() - 1; i >= 0; i--) 
        {
            Particle p = particles.get(i);
            p.update();
            p.display();
    
            if (p.isDead()) 
            {
                particles.remove(i);
            }
        }
    
        if (particles.isEmpty()) 
        {
            particleEffect = false; 
            audioSource.stage1.stop();
            NextStage = true;
        }
    }

    /*-------------------------------------------------------------------------------------------------------------------------*/

    void setRandomCorePosition() 
    {
        int randomIndex = int(random(corePositions.length)); 
        PVector randomPosition = corePositions[randomIndex];
        Core = new Item(randomPosition.x, randomPosition.y, "Image/Stage1/Core.png");
    }
    
    void updateCorePosition() 
    {
        int currentTime = millis();
        if (currentTime - lastChangeTime > changeInterval) 
        {
            setRandomCorePosition();
            if(audioSource.move != null && !audioSource.move.isPlaying())
            {
               audioSource.move.stop(); 
               audioSource.move.play();
            }               
            lastChangeTime = currentTime; 
        }
    }

    /*-------------------------------------------------------------------------------------------------------------------------*/

    void runJumpMap() 
    {
        for (Platform platform : platforms)
        {
            platform.display();
        }      
        PlatformCollision();
        Ruku.update();
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    void PlatformCollision() 
    {
        if (NextStage)
        {
            Ruku.motion.jumping = true;
            Ruku.motion.jumpSpeed += Ruku.motion.gravity;
            return;
        }
        
        boolean onPlatform = false;
        float characterHeight = 128;         
        float characterWidth = 50;         
        float characterBottom = Ruku.motion.y + characterHeight;
    
        for (Platform platform : platforms) 
        {
            boolean verticalCollision = characterBottom >= platform.y && characterBottom <= platform.y + 10;
            boolean horizontalCollision = Ruku.motion.x - characterWidth < platform.x && Ruku.motion.x + characterWidth > platform.x - platform.w/2;
            if (verticalCollision && horizontalCollision) 
            {
                if (Ruku.motion.jumpSpeed >= 0) 
                { 
                    Ruku.motion.y = platform.y - characterHeight; 
                    Ruku.motion.jumpSpeed = 0;
                    onPlatform = true;
                }
                break; 
            }
        }
    
        if (!onPlatform) 
        {
            Ruku.motion.jumping = true; 
        }
        else
        {
            Ruku.motion.jumping = false;
        }
    }
        
    /*-------------------------------------------------------------------------------------------------------------------------*/
        
    void setupJumpMap() 
    {
        platforms.clear();
        platforms.add(new Platform(40, height - 400, 100, 10));
        platforms.add(new Platform(100, height - 580, 100, 10));
        platforms.add(new Platform(240, height - 500, 100, 10));
        platforms.add(new Platform(280, height - 280, 100, 10));
        platforms.add(new Platform(380, height - 400, 100, 10));
        platforms.add(new Platform(400, height - 100, 100, 10)); 
        platforms.add(new Platform(420, height - 610, 100, 10));
        platforms.add(new Platform(550, height - 180, 100, 10));
        platforms.add(new Platform(560, height - 350, 100, 10));
        platforms.add(new Platform(600, height - 520, 100, 10));
        platforms.add(new Platform(700, height - 260, 100, 10));
        platforms.add(new Platform(770, height - 430, 100, 10));
        platforms.add(new Platform(860, height - 600, 100, 10));
        platforms.add(new Platform(900, height - 200, 100, 10));
        platforms.add(new Platform(980, height - 480, 100, 10));
        platforms.add(new Platform(1030, height - 300, 100, 10));
        platforms.add(new Platform(1100, height - 560, 100, 10));
    }    

    /*-------------------------------------------------------------------------------------------------------------------------*/

     void KeyPressed()
     {
        if (key == 'e' || key == 'E') 
        {
            /* Memo */
            if (dist(Ruku.motion.x, Ruku.motion.y, Memo.x, Memo.y) < 100) 
            {
                if(audioSource.paper != null)
                {
                    audioSource.paper.stop(); 
                    audioSource.paper.setVolume(10);
                    audioSource.paper.play();
                }
                showSequence = true;
                textTimer = millis();
            }
            
            /* FuseBox */
            if (dist(Ruku.motion.x, Ruku.motion.y, FuseBox_1.x, FuseBox_1.y) < 100 && dist(Ruku.motion.x, Ruku.motion.y, Memo.x, Memo.y) > 100) 
            {
                showSequence = false;

                if(audioSource.open != null)
                {
                    audioSource.open.play();
                }
                
                squares.clear();
                float startX = width / 2 - (4 * 120 / 2);
                float centerY = height / 2 - 50;

                for (int i = 0; i < 4; i++)
                {
                    squares.add(new Square(startX + i * 120, centerY));
                }
                squareIndex = 0;
                squareTimer = millis();
                FuseBox_1.change("Source/Image/Stage1/FuseBox_2.png", 200, 540);
            }
            
            /* Core */
            if (dist(Ruku.motion.x, Ruku.motion.y, Core.x, Core.y) < 80) 
            {
              
                  core = true;
                 if(audioSource.bling != null)
                 {
                     audioSource.bling.setVolume(-8);
                     audioSource.bling.play();
                 }
                 
                for (int i = 0; i < 50; i++) 
                {
                    particles.add(new Particle(Core.x + random(-10, 10), Core.y + random(-10, 10)));
                }
                particleEffect = true;
              }
        }
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/

    void MousePressed() 
    {
        if (!squares.isEmpty() && !clear)
        {
           if(audioSource.click != null)
           {
               audioSource.click.stop(); 
               audioSource.click.setVolume(10);
               audioSource.click.stop(); 
               audioSource.click.play();
           }

            for (Square square : squares) 
            {
                if (mouseX > square.x && mouseX < square.x + 100 && mouseY > square.y && mouseY < square.y + 100) 
                {
                    square.nextColor();
                    if (checkSquaresCompleted()) 
                    {                         
                        audioSource.ticking.stop();
                        if(audioSource.correct != null)
                        {
                            audioSource.correct.stop(); 
                            audioSource.correct.setVolume(8);
                            audioSource.correct.play();
                        }
                        delayTimer = millis(); 
                        clear = true;
                    }
                    break;
                }
            }
        }
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
    void updateClearStatus()
    {
        if (clear && millis() - delayTimer > 1500) 
        {
            squares.clear();     
            stageChanged = true; 
            setupJumpMap();      
            clear = false;       
        }
    }
}
