// https://stackoverflow.com/a/17260533 //<>// //<>// //<>// //<>//
PixelBuffer pixBuffer;
PixelBuffer textureBuffer;
PixelBuffer skyBuffer;

MaskBuffer mskBuffer;
HalfPixelBuffer halfBuffer;

Renderer draw;

PImage tex = null;
PImage sky = null;

final boolean usingHalf = true;
final boolean grayscale = false;
final boolean testing = true;
final boolean debug = false;

final int _width = 200;
final int _height = 200;

final boolean hq = true;
final int psize = 1; // Pixel Size

int delta;
int deltaTick, startTick, endTick;

int rectX = 0, 
    rectY = 0;

void setup()
{   
    String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    String url = urls[0]; // Gets link to test image
    String type = url.substring(url.length() - 3); // https://stackoverflow.com/a/15253508
    tex = loadImage(url, type);

    sky = loadImage("https://i.vimeocdn.com/video/439972201_1280x720.jpg", "jpg");

    size(320, 320);
    surface.setSize(_width * psize, _height * psize);

    pixBuffer = new PixelBuffer(_width, _height);

    textureBuffer = new PixelBuffer(200, 200);
    if (tex != null)
    {
        textureBuffer.imageTex(tex, grayscale);
    }

    skyBuffer = new PixelBuffer(_width, _height);
    if (sky != null)
    {
        skyBuffer.imageTex(sky, grayscale);
    }

    mskBuffer = new MaskBuffer(_width, _height);
    mskBuffer.makeNotMask();

    halfBuffer = new HalfPixelBuffer(_width, _height);

    draw = new Renderer(psize, hq, usingHalf);

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

    noStroke();

    background(0);

    skyBuffer.shift(1);

    pixBuffer.flush();
    pixBuffer.stampRect(0, 0, _width, _height, color(255, 128, 255));
    pixBuffer.stampImage(rectX, rectY, textureBuffer);

    halfBuffer.MakeHalfPixels(pixBuffer, mskBuffer);
    draw.HalfFilterFirst(halfBuffer, mskBuffer, _width, _height);
    draw.HalfFilterLast(halfBuffer, mskBuffer, _width, _height);
    draw.Raw(pixBuffer, _width, _height);
    draw.FilterLast(pixBuffer, mskBuffer, _width, _height);

    if (debug)
    {
        endTick = millis();
        deltaTick = endTick - startTick;
        println(deltaTick + "ms hq:" + hq + " half:" + usingHalf);
    }

    if (testing)
    {
        println(frameRate, frameCount);
        if (frameCount == _width*_height)
        {
            int start = delta;
            int now = millis();
            delta = now - start;
            print(String.format("%s-%s = %s", now, start, delta));
            stop();
        }
    }
}
