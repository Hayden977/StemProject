color[] pixBuffer;
int[] mskBuffer;
int[] halfBuffer;
                
int _width; // Array width
int _height; // Array height
int _len; // Array length

PImage img = null;

final boolean usingHalf = false;
final boolean grayscale = false;
final boolean testing = false;
final boolean ticking = true;
final int psize = 1; // Pixel Size

int delta;
int deltaTick, startTick, endTick;

void setup()
{   
    String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    String url = urls[0]; // Gets link to test image
    String type = url.substring(url.length() - 3); // https://stackoverflow.com/a/15253508
    img = loadImage(url, type);
    
    if (img != null)
    {
        _width = img.width;
        _height = img.height;
    }
    else
    {
        _width = 320;
        _height = 320;
    }
    
    size(320, 320); //<>//
    surface.setSize(_width * psize, _height * psize);
    
    _len = _width * _height;  
    pixBuffer = new color[_len];
    mskBuffer = new color[_len];
        
    if (img != null)
    {
        img.loadPixels(); //<>//
        
        if (grayscale)
        {
            for (int i = 0; i < (img.pixels.length); i++) 
            {
                int a = img.pixels[i] >> 16 * 0 & 0xFF; // Extract alpha component
                int r = img.pixels[i] >> 16 * 1 & 0xFF; // Extract red component
                int g = img.pixels[i] >> 16 * 2 & 0xFF; // Extract green component
                int b = img.pixels[i] >> 16 * 3 & 0xFF; // Extract blue component
                int average = int((r + g + b) / 3);
                pixBuffer[i] = color(average);
            }
        }
        else
        {
            for (int i = 0; i < (img.pixels.length); i++) 
            {
                pixBuffer[i] = img.pixels[i];
            }
        }
        mskBuffer = MakeNotMask(_width, _height);
    }
    else
    {
        pixBuffer = MakeRandom(_width, _height);
        mskBuffer = MakeNotMask(_width, _height);
    }
    
    frameRate(1000);
    
    if (testing)
    {
        delta = millis();
    }
}

void draw()
{
    if (ticking)
    {
        startTick = millis();
    }
    
    clear();
    noStroke();
    
    background(0);
    
    if (usingHalf)
    {
        pixBuffer = MakeShift(pixBuffer);
        halfBuffer = MakeHalfPixels(pixBuffer, mskBuffer, _width, _height);
        //DrawHalfFilterFirst(halfBuffer, mskBuffer, _width, _height);
        DrawHalfFilterLast(halfBuffer, mskBuffer, _width, _height);
    }
    else
    {
        pixBuffer = MakeShift(pixBuffer);
        DrawRaw(pixBuffer, _width, _height);
        //DrawFilterFirst(pixBuffer, mskBuffer, _width, _height);
        //DrawFilterLast(pixBuffer, mskBuffer, _width, _height);
        //DrawInterlace(pixBuffer, _width, _height);
    } //<>//
    
    if (ticking)
    {
        endTick = millis();
        deltaTick = endTick - startTick;
        println(deltaTick + "ms");
    }
    
    if (testing)
    {
        println(frameRate, frameCount);
        if (frameCount == _len)
        {
            int start = delta;
            int now = millis();
            delta = now - start;
            print(String.format("%s-%s = %s", now, start, delta));
            stop();
        }
    }
}
