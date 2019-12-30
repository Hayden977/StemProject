int[] pix;
int[] msk;
int[] halfpix;
                
final int psize = 1; // Pixel Size
int _width; // Array width
int _height; // Array height
int _len; // Array length

final float cmax = 255 / 255; // Maximum "color" value in array

PImage img = null;

//int delta;

void setup()
{   
    //String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    //String url = urls[0]; // Gets link to test image
    //String type = url.substring(url.length() - 3); // https://stackoverflow.com/a/15253508
    //img = loadImage(url, type);
    
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
    println(width, height);
    
    _len = _width * _height;  
    pix = new int[_len];
    msk = new int[_len];
    
    int[] def_pix = {10, 15, 30, 15, 
                     10, 30, 30, 30, 
                     10, 15, 30, 15, 
                     05, 10, 10, 10};
    
    int[] def_msk = {00, 01, 00, 01, 
                     01, 00, 01, 00,
                     00, 01, 00, 01,
                     01, 00, 01, 00};
        
    if (img != null)
    {
        img.loadPixels(); //<>//
    
        for (int i = 0; i < (img.pixels.length); i++) 
        {
            int a = img.pixels[i] >> 16 * 0 & 0xFF; // Extract alpha component
            int r = img.pixels[i] >> 16 * 1 & 0xFF; // Extract red component
            int g = img.pixels[i] >> 16 * 2 & 0xFF; // Extract green component
            int b = img.pixels[i] >> 16 * 3 & 0xFF; // Extract blue component
            int average = int((r + g + b) / 3);
            pix[i] = average;
        }
        msk = MakeNotMask(_width, _height);
        halfpix = MakeHalfPixels(pix, msk, _width, _height);
    }
    else
    {
        pix = MakeRandom(_width, _height);
        msk = MakeNotMask(_width, _height);
    }
    
    frameRate(1000);
    
    //delta = millis();
}

void draw()
{
    //int startTick = millis();
    
    clear();
    noStroke();
    
    background(0);
    
    pix = MakeShift(pix);
    //halfpix = MakeHalfPixels(pix, msk, _width, _height);
    
    DrawRaw(pix, _width, _height);
    //DrawFilterFirst(pix, msk, _width, _height);
    //DrawFilterLast(pix, msk, _width, _height);
    //DrawInterlace(pix, _width, _height); //<>//
    //DrawHalfFilterFirst(halfpix, msk, _width, _height);
    //DrawHalfFilterLast(halfpix, msk, _width, _height);
    
    //int endTick = millis();
    //delta = endTick - startTick;
    
    //printArray(pix);
    println(frameRate, frameCount);
    //if (frameCount == _len)
    //{
    //    int start = delta;
    //    int now = millis();
    //    delta = now - start;
    //    print(String.format("%s-%s = %s", now, start, delta));
    //    stop();
    //}
}
