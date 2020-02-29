PixelBuffer pixBuffer;
PixelBuffer textureBuffer;
PixelBuffer skyBuffer;

MaskBuffer mskBuffer;
CompressedPixelBuffer compressedBuffer;

Renderer draw;

PImage tex = null;
PImage sky = null;

final boolean grayscale = false;
final boolean testing = true;
final boolean debug = true;

final int w_width = 1280;
final int w_height = 720;

int delta;
int deltaTick, startTick, endTick;

int rectX = 0, 
    rectY = 0;

final int COMP_FULL = 1;
final int COMP_HALF = 2;
final int COMP_QUARTER = 4;
final int COMP_EIGHTH = 8;
final int COMP_SIXTEENTH = 16;

final int MAX_FRAME_TIME = 17; // The maxiumum time a time can take to draw, in this case 16.67
final int MAX_CPU_TIME = 7; // The maximum time a cpu can operate
final int GPU_THRESH = MAX_FRAME_TIME - MAX_CPU_TIME; // The maximum time the gpu can operate

void settings()
{
    size(w_width, w_height);
    noSmooth();
}

void setup()
{   
    String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    String url = urls[0]; // Gets link to test image
    String type = url.substring(url.length() - 3); // https://stackoverflow.com/a/15253508
    tex = loadImage(url, type);

    sky = loadImage("https://i.vimeocdn.com/video/439972201_1280x720.jpg", "jpg");

    pixBuffer = new PixelBuffer(w_width, w_height);

    textureBuffer = new PixelBuffer(200, 200);
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

    compressedBuffer = new CompressedPixelBuffer(w_width, w_height, COMP_HALF);

    draw = new Renderer();

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

    startTick = millis();

    skyBuffer.shift(1);

    pixBuffer.flush();
    pixBuffer.stampRect(0, 0, w_width, w_height, color(255, 128, 255));
    pixBuffer.stampImage(0, 0, skyBuffer);
    pixBuffer.stampImage(rectX, rectY, textureBuffer);
    compressedBuffer.MakeCompressedPixels(pixBuffer, mskBuffer);

    int cpu2 = millis();

    int cpu = cpu2 - cpu1;
    int gpu1, gpu2;
    int gpu = 0;
    //  vvvv Change this to enable 'lag frames'
    if (true || cpu <= MAX_CPU_TIME)
    {
        gpu1 = millis();
        noStroke();
        clear();
        background(0);
        SATURATE(compressedBuffer, 1.0f);
        //draw.CompressedFilterFirst(compressedBuffer, mskBuffer, w_width, w_height);
        draw.CompressedFilterLast(compressedBuffer, mskBuffer, w_width, w_height);
        //draw.Raw(pixBuffer, w_width, w_height);
        //draw.FilterLast(pixBuffer, mskBuffer, w_width, w_height);
        //draw.Interlace(pixBuffer, w_width, w_height);
        gpu2 = millis();
        gpu = gpu2 - gpu1;
    }

    println((cpu + gpu) + "ms c:" + cpu + " g:" + gpu + " fr:" + frameRate);
}
