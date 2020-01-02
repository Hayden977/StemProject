// https://stackoverflow.com/a/17260533
color[][] pixBuffer;
color[][] textureBuffer;
int[][] mskBuffer;
int[][] halfBuffer;

PImage img = null;

final boolean usingHalf = false;
final boolean grayscale = false;
final boolean testing = false;
final boolean debug = false;

final int _width = 640;
final int _height = 360;

boolean hq = true;
final int psize = 1; // Pixel Size

int delta;
int deltaTick, startTick, endTick;

int rectX = 15,
    rectY = 15,
    rectW = 40,
    rectH = 40;

void setup()
{   
    String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    String url = urls[0]; // Gets link to test image
    String type = url.substring(url.length() - 3); // https://stackoverflow.com/a/15253508
    img = loadImage(url, type); //<>//
    
    size(320, 320); //<>//
    surface.setSize(_width * psize, _height * psize);
    
    pixBuffer = new color[_width][_height];
    
    textureBuffer = new color[200][200];
    if (img != null)
    {
        textureBuffer = MakeTextureFromImage(img, 200, 200, grayscale);
    }
    else {
        textureBuffer = MakeRandom(200, 200);
    }
    
    mskBuffer = new color[_width][_height];
    mskBuffer = MakeNotMask(_width, _height); //<>//
    
    frameRate(1000);
    
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
    
    pixBuffer = new color[_width][_height];
    pixBuffer = StampRect(pixBuffer, 0, 0, _width, _height, color(255, 0, 0));
    pixBuffer = StampImage(pixBuffer, rectX, rectY, textureBuffer, 200, 200);
    
    if (usingHalf)
    {
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
        if (hq)
        {
            DrawRaw(pixBuffer, _width, _height);
        }
        else
        {
            DrawFilterLast(pixBuffer, mskBuffer, _width, _height);
        }
    } //<>//
    
    if (debug)
    {
        endTick = millis();
        deltaTick = endTick - startTick;
        println(deltaTick + "ms hq:" + hq + " half:" + usingHalf);
    }
    
    if (testing)
    {
        println(frameRate, frameCount);
        if (frameCount == 200*200)
        {
            int start = delta;
            int now = millis();
            delta = now - start;
            print(String.format("%s-%s = %s", now, start, delta));
            stop();
        }
    }
    
    rectX = mouseX - 100;
    rectY = mouseY - 100;
}
