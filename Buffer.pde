static class Buffer 
{
    int w, h;
    color[][] buffer;

    Buffer(int _w, int _h)
    {
        w = _w;
        h = _h;
        buffer = new color[_h][_w];
    }

    void flush()
    {
        for (int y = 0; y < (this.h); y++) 
            for (int x = 0; x < (this.w); x++)
                this.buffer[y][x] = 0;
    }

    void shift(int shift) // https://stackoverflow.com/a/34277492
    {
        color[][] temp = this.buffer;
        for (int row = 0; row < temp.length; row++) {
            int rowLength = temp[row].length;

            // keep shift within bounds of the array
            shift = shift % rowLength;

            // copy out elements that will "fall off"
            color[] tmp = new color[shift];
            for (int i = 0; i < shift; i++) {
                tmp[i] = temp[row][i];
            }

            // shift like normal
            for (int col = 0; col < rowLength - shift; col++) {
                temp[row][col] = temp[row][col + shift];
            }

            // copy back the "fallen off" elements
            for (int i = 0; i < shift; i++) {
                temp[row][i + (rowLength - shift)] = tmp[i];
            }
        }
        this.buffer = temp;
    }

    static int[] Convert1dTo2d(int index, int w, int h)
    {
        int[] temp = new int[2];
        temp[0] = index % w; // X
        temp[1] = index / h; // Y
        return temp;
    }

    static int Convert2dTo1d(int x, int y, int w)
    {
        int rowOffset = y * w;
        int xOffset = x;
        return rowOffset + xOffset;
    }
}

class PixelBuffer extends Buffer
{
    color err = color(255, 128, 255);
    color transparent = color(128, 255, 255);
    PixelBuffer(int _w, int _h)
    {
        super(_w, _h);
    }

    void colorTex(int r, int g, int b)
    {
        for (int y = 0; y < (this.h); y++) 
            for (int x = 0; x < (this.w); x++)
                this.buffer[y][x] = color(r, g, b);
    }

    void mappedTex()
    {
        float r, g, b;
        for (int y = 0; y < this.h; y++)
            for (int x = 0; x < this.w; x++)
            {
                r = map(y, 0, this.h, 0, 255);
                g = map(x, 0, this.w, 0, 255);
                b = map(Buffer.Convert2dTo1d(x, y, this.w), 0, this.w * this.h, 0, 255);
                this.buffer[y][x] = color(r, g, b);
            }
    }

    void randomTex()
    {
        int valr, valg, valb;
        for (int y = 0; y < this.h; y++)
            for (int x = 0; x < this.w; x++)
            {
                valr = int(random(255));
                valg = int(random(255));
                valb = int(random(255));
                this.buffer[y][x] = color(valr, valg, valb);
            }
    }

    void imageTex(PImage im, boolean isGray)
    {
        im.loadPixels();
        if (isGray)
            for (int y = 0; y < (this.h); y++) 
                for (int x = 0; x < (this.w); x++)
                {
                    int pixelIndex, a, r, g, b, average;
                    pixelIndex = Convert2dTo1d(x, y, w);
                    a = im.pixels[pixelIndex] >> 16 * 0 & 0xFF; // Extract alpha component
                    r = im.pixels[pixelIndex] >> 16 * 1 & 0xFF; // Extract red component
                    g = im.pixels[pixelIndex] >> 16 * 2 & 0xFF; // Extract green component
                    b = im.pixels[pixelIndex] >> 16 * 3 & 0xFF; // Extract blue component
                    average = int((r + g + b) / 3);
                    this.buffer[y][x] = color(average);
                } 
            else
            for (int y = 0; y < (this.h); y++) 
                for (int x = 0; x < (this.w); x++)
                {
                    int pixelIndex = Convert2dTo1d(x, y, w);
                    this.buffer[y][x] = im.pixels[pixelIndex];
                }
    }

    void stampRect(int rx, int ry, int rw, int rh, color c)
    {
        int xMin = rx, xMax = rx + rw;
        int yMin = ry, yMax = ry + rh;
        if (xMin < 0) xMin = 0;
        if (xMax > w_width) xMax = w_width;
        if (yMin < 0) yMin = 0;
        if (yMax > w_height) yMax = w_height;
        for (int y = yMin; y < yMax; y++)
            for (int x = xMin; x < xMax; x++)
                this.buffer[y][x] = c;
    }

    void stampImage(int rx, int ry, PixelBuffer im)
    {
        stampImage(rx, ry, im, im.w, im.h);
    }

    void stampImage(int rx, int ry, PixelBuffer im, int cx, int cy)
    {
        int xMin = rx, xMax = rx + cx;
        int yMin = ry, yMax = ry + cy;
        if (xMin < 0) xMin = 0;
        if (xMax > w_width) xMax = w_width;
        if (yMin < 0) yMin = 0;
        if (yMax > w_height) yMax = w_height;
        for (int y = yMin; y < yMax; y++)
            for (int x = xMin; x < xMax; x++)
            {
                int im_x = x - (rx);
                int im_y = y - (ry);
                this.buffer[y][x] = im.buffer[im_y][im_x];
            }
    }
}

class CompressedPixelBuffer extends PixelBuffer
{
    int hw, hh;
    int comp;
    CompressedPixelBuffer(int _w, int _h, int c)
    {
        super(_w / c, _h / c);
        comp = c;
        hw = _w / c;
        hh = _h / c;
    }

    void MakeCompressedPixels(Buffer p, Buffer m)
    {
        for (int y = 0; y < p.h; y++) // Go through mask
            for (int x = 0; x < p.w; x++)
                if (m.buffer[y][x] != this.transparent) // If can see through mask
                    //int x_index = x / 2; // Transform mask index to pixel index
                    //int y_index = y / 2; // Transform mask index to pixel index
                    this.buffer[y / this.comp][x / this.comp] = p.buffer[y][x];
    }
}

class MaskBuffer extends PixelBuffer
{
    MaskBuffer(int _w, int _h)
    {
        super(_w, _h);
    }

    void makeNotMask()
    {
        int val;
        for (int y = 0; y < this.h; y++) // y, height, row, etc. 
            for (int x = 0; x < this.w; x++) // x, width, column, etc.
                if (y % 2 == 1) // Odd row
                {
                    val = x % 2; // 0, 1, 0, 1, ...
                    this.buffer[y][x] = val == 0 ? this.transparent : color(0, 0, 0);
                } else if (y % 2 == 0) // Even row
                {
                    val = -(x % 2) + 1; // 1, 0, 1, 0, ...
                    this.buffer[y][x] = val == 0 ? this.transparent : color(0, 0, 0);
                }
    }
}
