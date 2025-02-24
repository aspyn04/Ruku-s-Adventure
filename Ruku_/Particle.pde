class Particle 
{
    float x, y;          
    float angle, radius; 
    float angleSpeed;   
    float speed;          
    float size;          
    float lifespan;       
    boolean expanding;    
    
    Particle(float x, float y)
    {
        this.x = x;
        this.y = y;
        this.angle = random(TWO_PI);     
        this.angleSpeed = random(0.1, 0.3);
        this.speed = random(5, 15);     
        this.size = random(5, 15);       
        this.radius = 0;               
        this.lifespan = 255;             
        this.expanding = false;        
    }

    void update() 
    {
        if (!expanding) 
        {
            x += cos(angle) * speed;
            y += sin(angle) * speed;
            radius += speed * 0.2;

            if (radius > 150) 
            {
                expanding = true;
            }
        } 
        
        else 
        {
            radius += 30; 
            lifespan -= 5;
        }
    }

    void display() 
    {
        noStroke();
        if (!expanding) 
        {
            fill(255, lifespan);
            ellipse(x, y, size, size);
        } 
        
        else 
        {
            fill(255, lifespan); 
            ellipse(x, y, radius, radius);
        }
    }

    boolean isDead() 
    {
        return lifespan <= 0;
    }
}
