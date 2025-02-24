class Item 
{
    float x, y;
    float baseY;
    float time = 0;
    PImage img;
    boolean isChanged;

    Item(float x, float y, String imgPath) 
    {
        this.x = x;
        this.y = y;
        this.baseY = y;
        this.img = loadImage(imgPath);
        this.isChanged = false;
    }

    void display() 
    {
        image(img, x, y);
    }
    
    void wave() 
    {
        time += 0.02;                    
        y = baseY + sin(time) * 12;      
        image(img, x, y);             
    }

    void change(String newImgPath, float newX, float newY)
    {
        this.img = loadImage(newImgPath);
        this.x = newX;
        this.y = newY;
        this.isChanged = true;
    }
}
