PixelBuffer pixBuffer;
PixelBuffer mapBuffer;
PixelBuffer textureBuffer;
PixelBuffer skyBuffer;

MaskBuffer mskBuffer;
CompressedPixelBuffer compressedBuffer;

Renderer draw;

PImage tex = null;
PImage sky720 = null;
PImage sky1080 = null;

final boolean grayscale = false;

final int w_width = 1920;
final int w_height = 1080;

int rectX = 0, 
    rectY = 0;

final int COMP_FACTORS[] = {1, 2, 4, 5, 8, 10, 16, 20, 40, 80};

int cpu, cpu1, cpu2;
int gpu, gpu1, gpu2;

final int MAX_FRAME_TIME = 14; // The maxiumum time a time can take to draw, in this case 16.67
final int MAX_CPU_TIME = 7; // The maximum time a cpu can operate
final int GPU_THRESH = MAX_FRAME_TIME - MAX_CPU_TIME; // The maximum time the gpu can operate

void settings()
{
    //fullScreen();
    size(w_width, w_height);
    noSmooth();
}

void setup()
{   
    String[] urls = loadStrings("tests.txt"); // Gets list of image tests to perform
    String url = urls[0]; // Gets link to test image
    String type = url.substring(url.length() - 3); // https://stackoverflow.com/a/15253508
    tex = loadImage(url, type);

    //sky720 = loadImage("https://i.vimeocdn.com/video/439972201_1280x720.jpg", "jpg")
    sky1080 = loadImage("https://images.wallpaperscraft.com/image/space_planet_light_galaxy_94490_1920x1080.jpg", "jpg");

    pixBuffer = new PixelBuffer(w_width, w_height);

    mapBuffer = new PixelBuffer(w_width, w_height);
    mapBuffer.mappedTex();

    textureBuffer = new PixelBuffer(200, 200);
    if (tex != null)
    {
        textureBuffer.imageTex(tex, grayscale);
        tex = null;
    }

    skyBuffer = new PixelBuffer(w_width, w_height);
    //if (sky720 != null)
    //{
        //skyBuffer.imageTex(sky720, grayscale);
        //sky720 = null;
    //}
    if (sky1080 != null)
    {
        skyBuffer.imageTex(sky1080, grayscale);
        sky1080 = null;
    }

    mskBuffer = new MaskBuffer(w_width, w_height);
    mskBuffer.makeNotMask();

    compressedBuffer = new CompressedPixelBuffer(w_width, w_height, COMP_FACTORS[0]);

    draw = new Renderer();

    frameRate(1000);
}

void draw()
{
    cpu1 = millis();

    rectX = mouseX;
    rectY = mouseY;

    skyBuffer.shift(1);

    pixBuffer.flush();
    pixBuffer.stampRect(0, 0, w_width, w_height, color(255, 128, 255));
    pixBuffer.stampImage(0, 0, mapBuffer);
    pixBuffer.stampImage(0, 0, skyBuffer);
    pixBuffer.stampImage(rectX, rectY, textureBuffer);
    compressedBuffer.MakeCompressedPixels(pixBuffer, mskBuffer);
    //SATURATE(compressedBuffer, 1.25f);

    cpu2 = millis();

    cpu = cpu2 - cpu1;
    gpu = 0;
    //  vvvv Change this to enable 'lag frames'
    if (true || cpu <= MAX_CPU_TIME)
    {
        gpu1 = millis();
        clear();
        background(0);
        draw.CompressedFilterFirst(compressedBuffer, mskBuffer, w_width, w_height);
        //draw.CompressedFilterLast(compressedBuffer, mskBuffer, w_width, w_height);
        //draw.Raw(pixBuffer, w_width, w_height);
        //draw.FilterLast(pixBuffer, mskBuffer, w_width, w_height);
        //draw.Interlace(pixBuffer, w_width, w_height);
        gpu2 = millis();
        gpu = gpu2 - gpu1;
    }

    println((cpu + gpu) + "ms c:" + cpu + " (" + MAX_CPU_TIME + ") g:" + gpu + " (" + GPU_THRESH + ") fr:" + frameRate);
}
