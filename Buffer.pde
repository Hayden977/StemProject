static class Buffer 
{
    int w, h;
    color[][] buffer;
    
    Buffer(int _w, int _h)
    {
        w = _w;
        h = _h;
        buffer = new color[_w][_h];
    }
    
    void flush()
    {
        for (int i = 0; i < (this.w); i++) 
        {
            for (int j = 0; j < (this.h); j++)
            {
                this.buffer[i][j] = 0;
            }
        }
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
    PixelBuffer(int _w, int _h)
    {
        super(_w, _h);
    }
    
    void colorTex(int r, int g, int b)
    {
        for (int i = 0; i < (this.w); i++) 
        {
            for (int j = 0; j < (this.h); j++)
            {
                this.buffer[i][j] = color(r, g, b);
            }
        }
    }
    
    void randomTex()
    {
        for (int i = 0; i < this.w; i++)
        {
            for (int j = 0; j < this.h; j++)
            {
                int valr = int(random(255));
                int valg = int(random(255));
                int valb = int(random(255));
                this.buffer[i][j] = color(valr, valg, valb);
            }
        }
    }
    
    void imageTex(PImage im, boolean isGray)
    {
        im.loadPixels();
        if (isGray)
        {
            for (int i = 0; i < (this.w); i++) 
            {
                for (int j = 0; j < (this.h); j++)
                {
                    int pixelIndex = Convert2dTo1d(i, j, w);
                    int a = im.pixels[pixelIndex] >> 16 * 0 & 0xFF; // Extract alpha component
                    int r = im.pixels[pixelIndex] >> 16 * 1 & 0xFF; // Extract red component
                    int g = im.pixels[pixelIndex] >> 16 * 2 & 0xFF; // Extract green component
                    int b = im.pixels[pixelIndex] >> 16 * 3 & 0xFF; // Extract blue component
                    int average = int((r + g + b) / 3);
                    this.buffer[i][j] = color(average);
                }
            }
        }
        else
        {
            for (int i = 0; i < (this.w); i++) 
            {
                for (int j = 0; j < (this.h); j++)
                {
                    int pixelIndex = Convert2dTo1d(i, j, w);
                    this.buffer[i][j] = im.pixels[pixelIndex];
                }
            }
        }
    }
    
    void stampRect(int rx, int ry, int rw, int rh, color c)
    {
        int xMin = rx, xMax = rx + rw;
        int yMin = ry, yMax = ry + rh;
        if (xMin < 0)
        {
            xMin = 0;
            // xMin is untouched, would be -1 + 4 for example
        }
        if (xMax > _width)
        {
            // xMin is untouched
            xMax = _width;
        }
        if (yMin < 0)
        {
            yMin = 0;
            // yMax is untouched, would be -2 + 5 for example
        }
        if (yMax > _height)
        {
            // yMin is untouched
            yMax = _height;
        }
        for (int i = xMin; i < xMax; i++)
        {
            for (int j = yMin; j < yMax; j++)
            {
                this.buffer[i][j] = c;
            }
        }
    }
    
    void stampImage(int rx, int ry, PixelBuffer im)
    {
        int xMin = rx, xMax = rx + im.w;
        int yMin = ry, yMax = ry + im.h;
        if (xMin < 0)
        {
            xMin = 0;
            // xMin is untouched, would be -1 + 4 for example
        }
        if (xMax > _width)
        {
            // xMin is untouched
            xMax = _width;
        }
        if (yMin < 0)
        {
            yMin = 0;
            // yMax is untouched, would be -2 + 5 for example
        }
        if (yMax > _height)
        {
            // yMin is untouched
            yMax = _height;
        }
        for (int i = xMin; i < xMax; i++)
        {
            for (int j = yMin; j < yMax; j++)
            {
                int im_x = i - rx;
                int im_y = j - ry;
                this.buffer[i][j] = im.buffer[im_x][im_y];
            }
        }
    }
    
}

class HalfPixelBuffer extends PixelBuffer
{
    int hw, hh;
    HalfPixelBuffer(int _w, int _h)
    {
        super(_w / 2, _h / 2);
        hw = _w / 2;
        hh = _h / 2;
    }
    
    void MakeHalfPixels(Buffer p, Buffer m)
    {
        for (int i = 0; i < p.w; i++) // Go through mask
        {
            for (int j = 0; j < p.h; j++)
            {
                if (m.buffer[i][j] == 1) // If can see through mask
                {
                    int i_index = i / 2; // Transform mask index to pixel index
                    int j_index = j / 2; // Transform mask index to pixel index
                    this.buffer[i_index][j_index] = p.buffer[i][j];
                }
            }
        }
    }
    
}

class MaskBuffer extends Buffer
{
    MaskBuffer(int _w, int _h)
    {
        super(_w, _h);
    }
    
    void makeNotMask()
    {
        for (int i = 0; i < this.w; i++) // y, height, row, etc. 
        {
            for (int j = 0; j < this.h; j++) // x, width, column, etc.
                {
                    if (i % 2 == 1) // Odd row
                    {
                        int val = j % 2; // 0, 1, 0, 1, ...
                        this.buffer[i][j] = val;
                    }
                    else if (i % 2 == 0) // Even row
                    {
                        int val = -(j % 2) + 1; // 1, 0, 1, 0, ...
                        this.buffer[i][j] = val;
                    }
                }
        }
    }
    
}
