/*-------------------------------------------------------------------------------------------------------------------------*/

/* Audio Source */
class AudioSource
{
    PApplet app; 

    AudioSource(PApplet app) 
    {
        this.app = app;
    }
    
    /* Title */
    AudioManager title;
    
    /* Stage1 */
    AudioManager stage1;
    AudioManager click, paper, crumple, open, bling, ticking, correct, changed, move;

    /* Stage2 */
    AudioManager stage2;
    AudioManager gravity;    

    /* Transition */
    AudioManager transition;

    /* Ending */
    AudioManager end;

    /* Core */
    AudioManager core;

    void setup()
    {
        /* Title */
        title = new AudioManager(app, "Source/Sound/Bgm/title.mp3");
        
        /* Stage1 */
        stage1 = new AudioManager(app, "Source/Sound/Bgm/stage1.mp3");    
        click = new AudioManager(app, "Source/Sound/Effect/click.mp3");
        paper = new AudioManager(app, "Source/Sound/Effect/paper.mp3");
        crumple = new AudioManager(app, "Source/Sound/Effect/crumple.mp3");
        open = new AudioManager(app, "Source/Sound/Effect/open.mp3");
        bling = new AudioManager(app, "Source/Sound/Effect/bling.mp3");
        ticking = new AudioManager(app, "Source/Sound/Effect/ticking.mp3");
        correct = new AudioManager(app, "Source/Sound/Effect/correct.mp3");
        changed = new AudioManager(app, "Source/Sound/Effect/changed.mp3");
        move = new AudioManager(app, "Source/Sound/Effect/move.mp3");

        /* Stage2 */
        stage2 = new AudioManager(app, "Source/Sound/Bgm/stage2.mp3");
        gravity = new AudioManager(app, "data/gravity.mp3");
        
        /* Transition */
        transition = new AudioManager(app, "Source/Sound/Effect/transition.mp3");    
        
        /* Ending */
        end = new AudioManager(app, "Source/Sound/Bgm/end.mp3");    
        
        /* Core */
        core = new AudioManager(app, "Source/Sound/Effect/core.mp3");    
      }
}

/*-------------------------------------------------------------------------------------------------------------------------*/
