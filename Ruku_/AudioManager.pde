/*-------------------------------------------------------------------------------------------------------------------------*/

/* Library */

import ddf.minim.*;
import ddf.minim.ugens.*;

/*-------------------------------------------------------------------------------------------------------------------------*/

/* Music Manager */
class AudioManager 
{
    Minim minim;
    AudioPlayer player;

    AudioManager(PApplet app, String filePath) 
    {
        minim = new Minim(app);
        player = minim.loadFile(filePath, 2048);
    }

    boolean isPlaying() 
    {
        return player != null && player.isPlaying();
    }
    
    /* Play */
    void play() 
    {
        if (player != null) 
        {
            player.play();
        }
    }

    /* Stop */
    void stop() 
    {
        if (player != null && player.isPlaying()) 
        {
            player.pause(); 
            player.cue(0);
        }
    }
    
    /* Loop */
    void loop() 
    {
        if (player != null) 
        {
            player.loop();
        }
    }
  
    /* Close */
    void close() 
    {
        if (player != null) 
        {
            player.close();
        }
        minim.stop();
    }

    /* Volume */
    void setVolume(float volume) 
    {
        if (player != null) 
        {
            player.setGain(volume);
        }
    }

    /* Buffer */
    float[] getLeftBuffer() 
    {
        if (player != null) 
        {
            return player.left.toArray();
        }
        return new float[0];
    }    
    float[] getRightBuffer() 
    {
        if (player != null) 
        {
            return player.right.toArray();
        }
        return new float[0];
    }    
}

/*-------------------------------------------------------------------------------------------------------------------------*/
