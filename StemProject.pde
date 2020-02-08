// https://stackoverflow.com/a/17260533 //<>//
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
final boolean testing = false;
final boolean debug = true;

final int w_width = 1280;
final int w_height = 720;

final boolean hq = true;
final int psize = 1; // Pixel Size

int delta;
int deltaTick, startTick, endTick;

int rectX = 0, 
    rectY = 0;

void setup()
{   
    String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    String url = urls[4]; // Gets link to test image
    String type = url.substring(url.length() - 3); // https://stackoverflow.com/a/15253508
    tex = loadImage(url, type);

    sky = loadImage("https://i.vimeocdn.com/video/439972201_1280x720.jpg", "jpg");

    size(320, 320);
    surface.setSize(w_width * psize, w_height * psize);

    pixBuffer = new PixelBuffer(w_width, w_height);

    textureBuffer = new PixelBuffer(400, 400);
    if (tex != null)
    {
        textureBuffer.imageTex(tex, grayscale);
    }

    skyBuffer = new PixelBuffer(w_width, w_height);
    if (sky != null)
    {
        skyBuffer.imageTex(sky, grayscale);
    }

    mskBuffer = new MaskBuffer(w_width, w_height);
    mskBuffer.makeNotMask();

    halfBuffer = new HalfPixelBuffer(w_width, w_height);

    draw = new Renderer(psize, hq, usingHalf);

    frameRate(1000);

    if (testing)
    {
        delta = millis();
    }
}

void draw()
{
    
    int cpu1 = millis();
    
    rectX = mouseX;
    rectY = mouseY;

    if (debug)
    {
        startTick = millis();
    }

    noStroke();

    background(0);

    skyBuffer.shift(1281);

    pixBuffer.flush();
    pixBuffer.stampRect(0, 0, w_width, w_height, color(255, 128, 255));
    pixBuffer.stampImage(0, 0, skyBuffer);
    pixBuffer.stampImage(rectX, rectY, textureBuffer);

    int cpu2 = millis();
    int gpu1 = millis();

    halfBuffer.MakeHalfPixels(pixBuffer, mskBuffer);
    draw.HalfFilterFirst(halfBuffer, mskBuffer, w_width, w_height);
    //draw.HalfFilterLast(halfBuffer, mskBuffer, w_width, w_height);
    //draw.Raw(pixBuffer, w_width, w_height);
    //draw.FilterLast(pixBuffer, mskBuffer, w_width, w_height);
    //draw.Interlace(pixBuffer, w_width, w_height);
    
    int gpu2 = millis();

    if (debug)
    {
        endTick = millis();
        deltaTick = endTick - startTick;
        int cpu = cpu2 - cpu1;
        int gpu = gpu2 - gpu1;
        println(deltaTick + "ms hq:" + hq + " half:" + usingHalf + " c:" + cpu + " g:" + gpu);
    }

    if (testing)
    {
        println(frameRate, frameCount);
        if (frameCount == w_width*w_height)
        {
            int start = delta;
            int now = millis();
            delta = now - start;
            print(String.format("%s-%s = %s", now, start, delta));
            stop();
        }
    }
}
