color[][] pixBuffer;
int[][] mskBuffer;
int[][] halfBuffer;
                
int _width; // Array width
int _height; // Array height
int _len; // Array length

PImage img = null;

final boolean usingHalf = true;
final boolean grayscale = false;
final boolean testing = false;
final boolean debug = true;

boolean hq = true;
final int psize = 1; // Pixel Size

int delta;
int deltaTick, startTick, endTick;

int rectX = 30,
    rectY = 20,
    rectW = 20,
    rectH = 20;

void setup()
{   
    String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    String url = urls[0]; // Gets link to test image //<>//
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
        _height = 180;
    }
    
    size(320, 320); //<>//
    surface.setSize(_width * psize, _height * psize);
    
    _len = _width * _height;  
    pixBuffer = new color[_width][_height];
    mskBuffer = new color[_width][_height];
        
    if (img != null)
    {
        img.loadPixels(); //<>//
        
        if (grayscale)
        {
            for (int i = 0; i < (img.pixels.length / _width); i++) 
            {
                for (int j = 0; j < (img.pixels.length / _height); j++)
                {
                    int pixelIndex = Convert2dTo1d(i, j, _width);
                    int a = img.pixels[pixelIndex] >> 16 * 0 & 0xFF; // Extract alpha component
                    int r = img.pixels[pixelIndex] >> 16 * 1 & 0xFF; // Extract red component
                    int g = img.pixels[pixelIndex] >> 16 * 2 & 0xFF; // Extract green component
                    int b = img.pixels[pixelIndex] >> 16 * 3 & 0xFF; // Extract blue component
                    int average = int((r + g + b) / 3);
                    pixBuffer[i][j] = color(average);
                }
            }
        }
        else
        {
            for (int i = 0; i < (img.pixels.length / _width); i++) 
            {
                for (int j = 0; j < (img.pixels.length / _height); j++)
                {
                    int pixelIndex = Convert2dTo1d(i, j, _width);
                    pixBuffer[i][j] = img.pixels[pixelIndex];
                }
            }
        }
        mskBuffer = MakeNotMask(_width, _height);
    }
    else
    {
        pixBuffer = MakeRandom(_width, _height);
        mskBuffer = MakeNotMask(_width, _height);
    }
    
    frameRate(60);
    
    if (testing)
    {
        delta = millis();
    }
}

void draw()
{
    if (debug)
    {
        startTick = millis();
    }
    
    clear();
    noStroke();
    
    background(0);
    
    if (usingHalf)
    {
        pixBuffer = MakeShift(pixBuffer, 1);
        halfBuffer = MakeHalfPixels(pixBuffer, mskBuffer, _width, _height);
        if (hq)
        {
            DrawHalfFilterFirst(halfBuffer, mskBuffer, _width, _height);
        }
        else
        {
            DrawHalfFilterLast(halfBuffer, mskBuffer, _width, _height);
        }
    }
    else
    {
        pixBuffer = MakeShift(pixBuffer, 1);
        if (hq)
        {
            DrawRaw(pixBuffer, _width, _height);
            //DrawFilterFirst(pixBuffer, mskBuffer, _width, _height);
        }
        else
        {
            DrawFilterLast(pixBuffer, mskBuffer, _width, _height);
            //DrawInterlace(pixBuffer, _width, _height);
        }
    } //<>//
    
    rectX++;
    
    if (debug)
    {
        endTick = millis();
        deltaTick = endTick - startTick;
        println(deltaTick + "ms hq:" + hq + " half:" + usingHalf);
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

void mousePressed()
{
    if(hq)
    {
        hq = false;
    }
    else
    {
        hq = true;
    }
}
