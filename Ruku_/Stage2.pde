import ddf.minim.*;  //<>// //<>// //<>// //<>// //<>// //<>//

class SecondStage 
{
    PApplet app;

    /* Character */
    CharacterSet Ruku;
    float characterWidth = 128;  
    float characterHeight = 128;     
    
    /* Background */
    PImage Stage_2_1, Stage_2_2, Stage_2_3, Stage_2_4;

    /* Item */
    Item Core;
    
    /* Switches */
    ArrayList<GravitySwitch> switches = new ArrayList<>();
    
    boolean ToggleOn = false;

    boolean onGround = true;
    
    boolean stageStarted = false;

    ArrayList<Platform> platforms = new ArrayList<>();
    ArrayList<Particle> particles = new ArrayList<>();

    boolean particleEffect = false;
    boolean particlesActive = false;

    boolean NextStage = false;
    
    AudioSource audioSource;

    /*-------------------------------------------------------------------------------------------------------------------------*/

    SecondStage(PApplet app, CharacterSet Ruku) 
    {
        this.app = app;
        this.Ruku = Ruku;
        
        audioSource = new AudioSource(app);
    }

    void setup() 
    {
        if (!stageStarted) 
        {
            onGround = true;

            setComponent();
            setupJumpMap();
            Ruku.motion.x = 80;
            Ruku.motion.y = 580;
            audioSource.setup();
            stageStarted = true;
            audioSource.stage2.loop();
        }
    }
    
    void run() 
    {
        setBack();
        displayComponent();                
        Logic();
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
  
    /* Set Component */
    void setComponent() 
    {
        Stage_2_1 = loadImage("Source/Image/Stage2/Stage_2_green.png");
        Stage_2_2 = loadImage("Source/Image/Stage2/Stage_2_blue.png");
        Stage_2_3 = loadImage("Source/Image/Stage2/Stage_2_pink.png");
        Stage_2_4 = loadImage("Source/Image/Stage2/Stage_2_purple.png");
        
        Core = new Item(1100, 80, "Source/Image/Stage2/Core_1.png");
        
        switches.add(new GravitySwitch(440, height - 160, audioSource, "Left"));
        switches.add(new GravitySwitch(190, 480, audioSource, "Down"));
        switches.add(new GravitySwitch(100, 220, audioSource, "Up"));
        switches.add(new GravitySwitch(350, 140, audioSource, "Right"));   
        switches.add(new GravitySwitch(1150, 300, audioSource, "Left"));   
        switches.add(new GravitySwitch(880, 360, audioSource, "Up"));   
        switches.add(new GravitySwitch(640, 200, audioSource, "Down"));    
        switches.add(new GravitySwitch(900, 600, audioSource, "Left"));    
    }
    
    /* Set Background */
    void setBack() 
    {
        if (Ruku.motion.onGravity == 0) 
        {
            background(Stage_2_1);
        } 
        
        else if (Ruku.motion.onGravity == 1) 
        {
            background(Stage_2_2);
        } 
        
        else if (Ruku.motion.onGravity == 2) 
        {
            background(Stage_2_3);
        }
        else 
        {
            background(Stage_2_4);
        }    
    }
    
    void displayComponent() 
    {
        Ruku.display();
        Core.display();
        drawSwitches();
    }
    
    void drawSwitches()
    {
        for (int i = 0; i < switches.size(); i++) 
        {
            GravitySwitch sw = switches.get(i);
            
            if (i == 5) 
            {
                if (ToggleOn)
                {
                    sw.draw();
                }
            }
            else 
            {
                sw.draw();
            }
        }
    }
         
    void Logic()
    {
        onGround = false;
        Core.wave();
        runJumpMap();
        SelectCore();
        
        drawWaveformBorder();
        drawPlatformWaveforms(platforms);
        
        particle();          
    }

    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    void SelectCore()
    {
        if (Ruku.motion.onGravity == 0 || Ruku.motion.onGravity == 1)
        {
            Core.img = loadImage("Source/Image/Stage2/Core_1.png");
        }
        else if (Ruku.motion.onGravity == 2 || Ruku.motion.onGravity == 3)
        {
            Core.img = loadImage("Source/Image/Stage2/Core_2.png");
        }       
    }    
    
    void drawWaveformBorder() 
    {
      if (audioSource.stage2 == null || !audioSource.stage2.isPlaying()) return;
      
      float[] leftBuffer = audioSource.stage2.getLeftBuffer();
      float[] rightBuffer = audioSource.stage2.getRightBuffer();
    
      int n = min(leftBuffer.length, rightBuffer.length);
      
      int step = max(1, n / 200); 
      
      color startColor, endColor;
      
      if (Ruku.motion.onGravity == 0) 
      {
        startColor = color(0, 255, 0);
        endColor   = color(100, 255, 100);
      }
      
      else if (Ruku.motion.onGravity == 1) 
      {
        startColor = color(0, 255, 255);
        endColor   = color(100, 255, 255);
        
      }       
      
      else if (Ruku.motion.onGravity == 2) 
      {
        startColor = color(255, 0, 255);
        endColor   = color(255, 100, 255);       
      } 
      
      else 
      { 
        startColor = color(138, 43, 226); 
        endColor = color(186, 85, 211);
      }
      
      float edge = 10;
      float amplitude = 10;
      
      ArrayList<PVector> topWave = new ArrayList<PVector>();
      ArrayList<PVector> bottomWave = new ArrayList<PVector>();
      ArrayList<PVector> leftWave = new ArrayList<PVector>();
      ArrayList<PVector> rightWave = new ArrayList<PVector>();
    
      for (int i = 0; i < n; i += step) 
      {
        float xTop = map(i, 0, n-1, 0, width);
        float yTop = edge + leftBuffer[i] * amplitude;
        topWave.add(new PVector(xTop, yTop));
    
        float xBottom = map(i, 0, n-1, 0, width);
        float yBottom = height - edge + leftBuffer[i] * amplitude;
        bottomWave.add(new PVector(xBottom, yBottom));
    
        float yLeft = map(i, 0, n-1, 0, height);
        float xLeft = edge + rightBuffer[i] * amplitude;
        leftWave.add(new PVector(xLeft, yLeft));
    
        float yRight = map(i, 0, n-1, 0, height);
        float xRight = width - edge + rightBuffer[i] * amplitude;
        rightWave.add(new PVector(xRight, yRight));
      }
      
      smooth();
      blendMode(BLEND);
      noStroke();
      
      for (int i = 0; i < 10; i++) 
      { 
        float inter = i/10.0;
        fill(lerpColor(startColor, endColor, inter), 20); 
        rect(0, 0, width, map(inter, 0, 1, 0, edge+amplitude*2));
      }
      
      for (int i = 0; i < 10; i++) 
      { 
        float inter = i/10.0;
        fill(lerpColor(startColor, endColor, inter), 20);
        rect(0, height - map(inter, 0, 1, 0, edge+amplitude*2), width, height);
      }
      
      for (int i = 0; i < 10; i++) 
      {
        float inter = i/10.0;
        fill(lerpColor(startColor, endColor, inter), 20);
        rect(0, 0, map(inter, 0, 1, 0, edge+amplitude*2), height);
      }
      
      for (int i = 0; i < 10; i++) 
      {
        float inter = i/10.0;
        fill(lerpColor(startColor, endColor, inter), 20);
        rect(width - map(inter, 0, 1, 0, edge+amplitude*2), 0, width, height);
      }
    
      strokeWeight(2);
      stroke(startColor);
      noFill();
    
      beginShape();
      if (topWave.size() > 2) 
      {
        curveVertex(topWave.get(0).x, topWave.get(0).y);
        for (PVector p : topWave) curveVertex(p.x, p.y);
        curveVertex(topWave.get(topWave.size()-1).x, topWave.get(topWave.size()-1).y);
      }
      endShape();
      
      beginShape();
      if (bottomWave.size() > 2) 
      {
        curveVertex(bottomWave.get(0).x, bottomWave.get(0).y);
        for (PVector p : bottomWave) curveVertex(p.x, p.y);
        curveVertex(bottomWave.get(bottomWave.size()-1).x, bottomWave.get(bottomWave.size()-1).y);
      }
      endShape();
      
      beginShape();
      if (leftWave.size() > 2) 
      {
        curveVertex(leftWave.get(0).x, leftWave.get(0).y);
        for (PVector p : leftWave) curveVertex(p.x, p.y);
        curveVertex(leftWave.get(leftWave.size()-1).x, leftWave.get(leftWave.size()-1).y);
      }
      endShape();
      
      beginShape();
      if (rightWave.size() > 2)
      {
        curveVertex(rightWave.get(0).x, rightWave.get(0).y);
        for (PVector p : rightWave) curveVertex(p.x, p.y);
        curveVertex(rightWave.get(rightWave.size()-1).x, rightWave.get(rightWave.size()-1).y);
      }
      endShape();
    }
    
    void drawPlatformWaveforms(ArrayList<Platform> platforms) 
    {
      if (audioSource.stage2 == null || !audioSource.stage2.isPlaying()) return;
    
      float[] leftBuffer = audioSource.stage2.getLeftBuffer();
      float[] rightBuffer = audioSource.stage2.getRightBuffer();
    
      int n = min(leftBuffer.length, rightBuffer.length);
      int step = max(1, n / 100); 
    
      color startColor, endColor;
      
      if (Ruku.motion.onGravity == 0) 
      {
        startColor = color(0, 255, 0);
        endColor   = color(100, 255, 100);
      } 
      
      else if (Ruku.motion.onGravity == 1) 
      {
        startColor = color(0, 255, 255);
        endColor   = color(100, 255, 255);
      }
      
      else if (Ruku.motion.onGravity == 2) 
      {
        startColor = color(255, 0, 255);
        endColor   = color(255, 100, 255);
      } 
      
      else { // GRAVITY_RIGHT
        startColor = color(138, 43, 226); 
        endColor = color(186, 85, 211);
      }
    
      for (Platform platform : platforms) 
      {
        float xStart = platform.x;
        float yStart = platform.y;
        float pWidth = platform.w;  
        float pHeight = platform.h; 
    
        ArrayList<PVector> topWave = new ArrayList<>();
        ArrayList<PVector> bottomWave = new ArrayList<>();
        ArrayList<PVector> leftWave = new ArrayList<>();
        ArrayList<PVector> rightWave = new ArrayList<>();
    
        for (int i = 0; i < n; i += step) 
        {
          float xTop = map(i, 0, n - 1, xStart, xStart + pWidth);
          float yTop = yStart + leftBuffer[i] * 5;
          topWave.add(new PVector(xTop, yTop));
    
          float xBottom = map(i, 0, n - 1, xStart, xStart + pWidth);
          float yBottom = yStart + pHeight + leftBuffer[i] * 5;
          bottomWave.add(new PVector(xBottom, yBottom));
    
          float yLeft = map(i, 0, n - 1, yStart, yStart + pHeight);
          float xLeft = xStart + rightBuffer[i] * 5;
          leftWave.add(new PVector(xLeft, yLeft));
    
          float yRight = map(i, 0, n - 1, yStart, yStart + pHeight);
          float xRight = xStart + pWidth + rightBuffer[i] * 5;
          rightWave.add(new PVector(xRight, yRight));
        }
    
        drawWaveLine(topWave, startColor, endColor);    
        drawWaveLine(bottomWave, startColor, endColor); 
        drawWaveLine(leftWave, startColor, endColor);   
        drawWaveLine(rightWave, startColor, endColor);  
      }
    }
    
    void drawWaveLine(ArrayList<PVector> wavePoints, color startColor, color endColor)
    {
      int n = wavePoints.size();
      if (n < 2) return;
    
      for (int i = 0; i < n - 1; i++) 
      {
        float inter = map(i, 0, n - 1, 0, 1);
        color c = lerpColor(startColor, endColor, inter);
    
        strokeWeight(2);
        stroke(c);
        noFill();
    
        beginShape();
        curveVertex(wavePoints.get(max(0, i - 1)).x, wavePoints.get(max(0, i - 1)).y);
        curveVertex(wavePoints.get(i).x, wavePoints.get(i).y);
        curveVertex(wavePoints.get(i + 1).x, wavePoints.get(i + 1).y);
        curveVertex(wavePoints.get(min(n - 1, i + 2)).x, wavePoints.get(min(n - 1, i + 2)).y);
        endShape();
      }
    }
    /*-------------------------------------------------------------------------------------------------------------------------*/

    /* Particle */
    void particle()
    {
        if (particleEffect) 
        {
            Particles();
        }
    }
    
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
            audioSource.stage2.stop();
            NextStage = true;
        }
    }   
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    class GravitySwitch 
    {
        float x, y;
        int vertexCount;
        float[] offsets; 
        float baseRadius; 
        float rotationAngle; 
        float rotationSpeed;
        boolean isSpiky; 
        AudioSource audioSource; 
        boolean isToggled;
        String action;

        GravitySwitch(float x, float y, AudioSource audioSource, String action) 
        {
            this.x = x;
            this.y = y;
            this.audioSource = audioSource;
            this.action = action;
    
            this.vertexCount = int(random(12, 20)); 
            this.baseRadius = 7; 
            this.rotationSpeed = random(0.01, 0.05); 
            this.isSpiky = random(1) > 0.5; 
    
            offsets = new float[vertexCount];
            for (int i = 0; i < vertexCount; i++) 
            {
                offsets[i] = random(0, 3); 
            }
            this.rotationAngle = random(TWO_PI); 
            this.isToggled = false;
        }

        void draw() 
        {
            noFill(); 
            strokeWeight(2); 
    
            if (Ruku.motion.onGravity == 0) 
            {
                stroke(0, 255, 0);
            } 
            
            else if (Ruku.motion.onGravity == 1) 
            {
                stroke(0, 255, 255);
            } 
            
            else if (Ruku.motion.onGravity == 2) 
            {
                stroke(255, 0, 255);
            } 
            
            else 
            {
                stroke(138, 43, 226);
            }
    
            if (audioSource.stage2 != null &&audioSource.stage2.isPlaying()) 
            {
                float[] leftBuffer = audioSource.stage2.getLeftBuffer();
                int bufferLength = min(leftBuffer.length, vertexCount);
    
                for (int i = 0; i < bufferLength; i++) 
                {
                    float waveValue = map(leftBuffer[i], -1, 1, -1, 1); 
                    offsets[i] += waveValue; 
                    offsets[i] = constrain(offsets[i], -3, 3); 
                }
            }

            pushMatrix();
            translate(x + baseRadius, y + baseRadius); 
            rotate(rotationAngle); 
            beginShape();
            for (int i = 0; i < vertexCount; i++) 
            {
                float angle = map(i, 0, vertexCount, 0, TWO_PI);
                float r = baseRadius + offsets[i];
                if (isSpiky && i % 2 == 0) 
                {
                    r += 3; 
                }
                float px = cos(angle) * r;
                float py = sin(angle) * r;
                vertex(px, py);
            }
            endShape(CLOSE);
            popMatrix();
    
            rotationAngle += rotationSpeed;
        }

        void toggle() 
        {
            if (!isToggled) 
            {
                switchmusic();      
                onGround = false;
                performAction();
                isToggled = true;
            }
            else 
            {
                isToggled = false;
            }
        }

        void performAction() 
        {
            switch (action) 
            {
                case "Left":
                    Left();
                    break;
                case "Right":
                    Right();
                    break;
                case "Up":
                    Up();
                    break;
                case "Down":
                    Down();
                    break;
                // 필요에 따라 더 많은 동작 추가 가능
            }
        }

        void Down() 
        {
            if (Ruku.motion.onGravity != 0) 
            {
                onGround = false;
                Ruku.motion.onGravity = 0;
            } 
            else 
            {
                onGround = false;
                Ruku.motion.onGravity = 1;
            }
            Ruku.motion.jumpSpeed = 0;
            Ruku.motion.jumping = true;
        }

        void Up() 
        {
            if (Ruku.motion.onGravity != 1) 
            {
                onGround = false;
                Ruku.motion.onGravity = 1; 
            } 
            else
            {
                onGround = false;
                Ruku.motion.onGravity = 0;
            }
            Ruku.motion.jumpSpeed = 0;
            Ruku.motion.jumping = true;
        }
        
        void Left() 
        {
            if (Ruku.motion.onGravity != 2) 
            {
                onGround = false;
                Ruku.motion.onGravity = 2;
            } 
            else 
            {
                onGround = false;
                Ruku.motion.onGravity = 3;
            }
            Ruku.motion.jumpSpeed = 0;
            Ruku.motion.jumping = true;
        }

        void Right() 
        {
            if (Ruku.motion.onGravity != 3) 
            {
                onGround = false;
                Ruku.motion.onGravity = 3;
            } 
            else 
            {
                onGround = false;
                Ruku.motion.onGravity = 2;
            }
            Ruku.motion.jumpSpeed = 0;
            Ruku.motion.jumping = true;
        }
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
    
    void PlatformCollision() 
    {
        float characterWidth = 50;
        float characterHeight = 128;
    
        float cx = Ruku.motion.x;
        float cy = Ruku.motion.y;
    
        float cLeft = cx;
        float cRight = cx + characterWidth;
        float cTop = cy;
        float cBottom = cy + characterHeight;
    
        boolean landedOnAnyPlatform = false; 
        float adjustedX = Ruku.motion.x;
        float adjustedY = Ruku.motion.y;
    
        for (Platform platform : platforms) 
        {
            float pLeft, pRight, pTop, pBottom;
    
            if (Ruku.motion.onGravity == 0 || Ruku.motion.onGravity == 1) 
            {
                pLeft = platform.x - 55; 
                pRight = platform.x + platform.w - 16;
                pTop = platform.y;
                pBottom = platform.y + platform.h;
            } 
            
            else 
            {
                pLeft = platform.x - 80; 
                pRight = platform.x + platform.w;
                pTop = platform.y + 20;
                pBottom = platform.y + platform.h - 24;
            }
    
            boolean overlapX = (cRight > pLeft && cLeft < pRight);
            boolean overlapY = (cBottom > pTop && cTop < pBottom);
    
            if (overlapX && overlapY) 
            {
                boolean isGroundCollision = false;
                float desiredX = adjustedX;
                float desiredY = adjustedY;
    
                switch (Ruku.motion.onGravity) 
                {
                    case 0: // Gravity Down
                        if (Ruku.motion.jumpSpeed > 0 && cBottom > pTop && cTop < pTop) 
                        {
                            desiredY = pTop - characterHeight;
                            isGroundCollision = true;
                        }
                        break;
                        
                    case 1: // Gravity Up
                        if (Ruku.motion.jumpSpeed < 0 && cTop < pBottom && cBottom > pBottom) 
                        {
                            desiredY = pBottom;
                            isGroundCollision = true;
                        }
                        break;
                        
                    case 2: // Gravity Left
                        if (Ruku.motion.jumpSpeed < 0 && cLeft < pRight && cRight > pRight) 
                        {
                            desiredX = pRight;
                            isGroundCollision = true;
                        }
                        break;
                        
                    case 3: // Gravity Right
                        if (Ruku.motion.jumpSpeed > 0 && cRight > pLeft && cLeft < pLeft) 
                        {
                            desiredX = pLeft - characterWidth;
                            isGroundCollision = true;
                        }
                        break;
                }
    
                if (isGroundCollision) 
                {
                    adjustedX = desiredX;
                    adjustedY = desiredY;
                    Ruku.motion.jumping = false;
                    landedOnAnyPlatform = true;
                } 
                
                else 
                {
                    float overlapLeftDist = cRight - pLeft;
                    float overlapRightDist = pRight - cLeft;
                    float overlapTopDist = cBottom - pTop;
                    float overlapBottomDist = pBottom - cTop;
    
                    float horizontalMin = min(overlapLeftDist, overlapRightDist);
                    float verticalMin = min(overlapTopDist, overlapBottomDist);
    
                    if (horizontalMin <= verticalMin) 
                    {
                        if (overlapLeftDist < overlapRightDist) 
                        {
                            adjustedX = cx - overlapLeftDist;
                        } 
                        
                        else 
                        {
                            adjustedX = cx + overlapRightDist;
                        }
                    } 
                    
                    else 
                    {
                        if (overlapTopDist < overlapBottomDist) 
                        {
                            adjustedY = cy - overlapTopDist;
                        } 
                        
                        else 
                        {
                            adjustedY = cy + overlapBottomDist;
                        }
                    }
                }
            }
        }
    
        Ruku.motion.x = adjustedX;
        Ruku.motion.y = adjustedY;
    
        if (landedOnAnyPlatform) 
        {
            Ruku.motion.jumpSpeed = 0; 
        }
        onGround = landedOnAnyPlatform;
    }



    /*-------------------------------------------------------------------------------------------------------------------------*/

    void setupJumpMap() 
    {
        platforms.clear();
        platforms.add(new Platform(158, 148, 136, 171));
        platforms.add(new Platform(430, 47, 116, 267));
        platforms.add(new Platform(575, 360, 199, 267));
        platforms.add(new Platform(970, 169, 267, 85));
        platforms.add(new Platform(1137, 372, 143, 348));
    }
    
    void runJumpMap() 
    {
        for (Platform platform : platforms) 
        {
            platform.InvisibleDisplay(); 
        }
        PlatformCollision();
        Ruku.motion.update();
    }
    
    /*-------------------------------------------------------------------------------------------------------------------------*/
       
    void switchmusic()
    {
        if(audioSource.gravity != null )
        {
            audioSource.click.setVolume(60);
            audioSource.gravity.stop(); 
            audioSource.gravity.play();
        }   
    }

    void KeyPressed() 
    {   
        if (key == 'e' || key == 'E') 
        {
            float RukuCenterX = Ruku.motion.x + characterWidth / 2;
            float RukuCenterY = Ruku.motion.y + characterHeight / 2;
            
            for (int i = 0; i < switches.size(); i++) 
            {
                GravitySwitch sw = switches.get(i);
                float switchCenterX = sw.x + 20 / 2;
                float switchCenterY = sw.y + 20 / 2;
                
                if (dist(RukuCenterX, RukuCenterY, switchCenterX, switchCenterY) < 100) 
                {
                    sw.toggle();
                    
                    // Switch7에 대한 특별한 처리
                    if (i == 6 && sw.isToggled) // 인덱스 6은 Switch7
                    {
                        ToggleOn = true;
                    }
                    else if (i == 6 && !sw.isToggled)
                    {
                        ToggleOn = false;
                    }
                }
            }
            
            if (dist(Ruku.motion.x, Ruku.motion.y, Core.x, Core.y) < 80) 
            {
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

    void keyReleased() 
    {
        if (key == 'e' || key == 'E') 
        {
            for (GravitySwitch sw : switches) 
            {
                sw.isToggled = false;
            }
            ToggleOn = false;
        }
    }    
}
