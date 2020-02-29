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
