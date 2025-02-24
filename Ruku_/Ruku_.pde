/*-------------------------------------------------------------------------------------------------------------------------*/

/* Character */
CharacterSet Ruku;

/* Stage */
Start start;
FirstStage firstStage;
Transition transition;
SecondStage secondStage;
BeforeEnding beforeEnding;
Ending End;

/* Current Stage */
int CurrentStage = 0;

/*-------------------------------------------------------------------------------------------------------------------------*/

/* Set */
void setup() 
{
    /* Background Size */
    size(1280, 720);
    
    /* Character Reset */
    Ruku = new CharacterSet(this, 80, 580);
}

/*-------------------------------------------------------------------------------------------------------------------------*/

/* Run */
void draw() 
{
    /* Reset Start*/
    if (CurrentStage == 0  && start == null)
    {
        start = new Start(this);
        start.setup();      
    }    
    
    /* Running Start */
    if (CurrentStage == 0 && start != null) 
    {
        start.run(); 
        
        if (start != null && start.NextStage) 
        {
            CurrentStage = 1; 
            start = null;
        }
    }
    
    /* Reset Stage1*/
    if (CurrentStage == 1  && firstStage == null)
    {
        firstStage = new FirstStage(this, Ruku);
        firstStage.setup();      
    }    
    
    /* Running Stage1 */
    if (CurrentStage == 1 && firstStage != null) 
    {
        firstStage.run(); 
        
        if (firstStage != null && firstStage.NextStage) 
        {
            CurrentStage = 2; 
            firstStage = null;
        }
    }
    
    /* Reset Transition */
    else if (CurrentStage == 2 && transition == null) 
    {
        transition = new Transition(this);
        transition.setup();    
    }
    
    /* Running Transition */
    else if (CurrentStage == 2 && transition != null) 
    {
        transition.run(); 
        if (transition != null && transition.NextStage) 
        {
            CurrentStage = 3; 
            transition = null;
        }
    }
    
    /* Reset Stage2 */
    else if (CurrentStage == 3 && secondStage == null) 
    {
        secondStage = new SecondStage(this, Ruku);
        secondStage.setup();    
    }
    
    /* Running Stage2 */
    else if (CurrentStage == 3 && secondStage != null) 
    {
        secondStage.run(); 
        if (secondStage != null && secondStage.NextStage) 
        {
            CurrentStage = 4; 
            transition = null;
        }    
      }
    
    /* Ending */
    else if (CurrentStage == 4 && beforeEnding == null) 
    {
        beforeEnding = new BeforeEnding(this);
        beforeEnding.setup();    
    }
    
    /* Running End */
    else if (CurrentStage == 4 && beforeEnding != null) 
    {
        beforeEnding.run(); 
        if (beforeEnding != null && beforeEnding.NextStage) 
        {
            CurrentStage = 5; 
            transition = null;
        }    
    }
    
    
    /* The End Reset */
    else if (CurrentStage == 5 && End == null) 
    {
        End = new Ending();
        End.setup();    
    }
    
    /* The End Run */
    else if (CurrentStage == 5 && End != null) 
    {
        End.run(); 
    }
}

/*-------------------------------------------------------------------------------------------------------------------------*/

/* Key Press */
void keyPressed() 
{
    if (Ruku != null && CurrentStage != 0 || CurrentStage != 2) 
    {
        Ruku.handleKeyReleased(key); // a, d, spacebar
    }
    
    if (CurrentStage == 0 && start != null) 
    {
        start.KeyPressed(); 
    }
    
    if (CurrentStage == 1 && firstStage != null) 
    {
        firstStage.KeyPressed(); 
    }

    else if (CurrentStage == 3 && secondStage != null) 
    {
        secondStage.KeyPressed(); 
    }

}

/* Key Release */
void keyReleased() 
{
    if (Ruku != null) 
    {
        Ruku.handleKeyPressed(key);
    }
}

/* Mouse Press */
void mousePressed() 
{
    if (CurrentStage == 1 && firstStage != null) 
    {
        firstStage.MousePressed();
    }
    
    if (CurrentStage == 4 && beforeEnding != null) 
    {
        beforeEnding.MousePressed();
    }
}

/* Mouse Release */
void mouseReleased() 
{
    if (CurrentStage == 4 && beforeEnding != null) 
    {
        beforeEnding.MouseReleased();
    }
}
