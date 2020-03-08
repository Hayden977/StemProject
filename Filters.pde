void LIGHTEN(PixelBuffer pb, float rc, float gc, float bc)
{
    for (int y = 0; y < pb.h; y++) 
        for (int x = 0; x < pb.w; x++)
        {
            int r = int(red(pb.buffer[y][x])); // Extract red component
            int g = int(green(pb.buffer[y][x])); // Extract green component
            int b = int(blue(pb.buffer[y][x])); // Extract blue component
            r *= rc;
            g *= gc;
            b *= bc;
            r = constrain(r, 0, 255);
            g = constrain(g, 0, 255);
            b = constrain(b, 0, 255);
            pb.buffer[y][x] = color(r, g, b);
        }
}

void LIGHTEN(PixelBuffer pb, float ac)
{
    LIGHTEN(pb, ac, ac, ac);
}

void SATURATE(PixelBuffer pb, float rc, float gc, float bc)
{
    for (int y = 0; y < pb.h; y++) 
        for (int x = 0; x < pb.w; x++)
        {
            int r = int(red(pb.buffer[y][x])); // Extract red component
            int g = int(green(pb.buffer[y][x])); // Extract green component
            int b = int(blue(pb.buffer[y][x])); // Extract blue component
            // https://alienryderflex.com/saturation.html
            float P = sqrt(r * r * 0.299 + g * g * 0.587 + b * b * 0.114);
            r = int(P + (r - P) * rc);
            g = int(P + (g - P) * gc);
            b = int(P + (b - P) * bc);
            r = constrain(r, 0, 255);
            g = constrain(g, 0, 255);
            b = constrain(b, 0, 255);
            pb.buffer[y][x] = color(r, g, b);
        }
}

void SATURATE(PixelBuffer pb, float sc)
{
    SATURATE(pb, sc, sc, sc);
}

void NN(PixelBuffer pb, int rx, int ry)
{
    // http://tech-algorithm.com/articles/nearest-neighbor-image-scaling/
    float x_scale = pb.w / float(rx);
    float y_scale = pb.h / float(ry);
    PixelBuffer temp = new PixelBuffer(rx, ry);
    int px, py;
    for (int y = 0; y < ry; y++)
        for (int x = 0; x < rx; x++)
        {
            py = floor(y * y_scale);
            px = floor(x * x_scale);
            temp.buffer[y][x] = pb.buffer[py][px];
        }
    pb.w = rx;
    pb.h = ry;
    pb.buffer = temp.buffer;
}

void NN(PixelBuffer pb, float s)
{
    NN(pb, int(pb.w * s), int(pb.h * s));
}

void ROTATE90(PixelBuffer pb)
{
    PixelBuffer temp = new PixelBuffer(pb.w, pb.h);
    for (int y = 0; y < pb.h; y++)
        for (int x = 0; x < pb.w; x++)
            temp.buffer[y][x] = pb.buffer[(pb.w - 1) - x][y];
    pb.buffer = temp.buffer;
}

void ROTATE180(PixelBuffer pb)
{
    PixelBuffer temp = new PixelBuffer(pb.w, pb.h);
    for (int y = 0; y < pb.h; y++)
        for (int x = 0; x < pb.w; x++)
            temp.buffer[y][x] = pb.buffer[(pb.h - 1) - y][(pb.w - 1) - x];
    pb.buffer = temp.buffer;
}

void ROTATE270(PixelBuffer pb)
{
    PixelBuffer temp = new PixelBuffer(pb.w, pb.h);
    for (int y = 0; y < pb.h; y++)
        for (int x = 0; x < pb.w; x++)
            temp.buffer[y][x] = pb.buffer[x][(pb.w - 1) - y];
    pb.buffer = temp.buffer;
}

void FLIPHORIZ(PixelBuffer pb)
{
    PixelBuffer temp = new PixelBuffer(pb.w, pb.h);
    for (int y = 0; y < pb.h; y++)
        for (int x = 0; x < pb.w; x++)
            temp.buffer[y][x] = pb.buffer[y][(pb.w - 1) - x];
    pb.buffer = temp.buffer;
}

void FLIPVERT(PixelBuffer pb)
{
    PixelBuffer temp = new PixelBuffer(pb.w, pb.h);
    for (int y = 0; y < pb.h; y++)
        for (int x = 0; x < pb.w; x++)
            temp.buffer[y][x] = pb.buffer[(pb.h - 1) - y][x];
    pb.buffer = temp.buffer;
}
