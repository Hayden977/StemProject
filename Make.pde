color[][] MakeRandom(int w, int h)
{
    int[][] p = new int[w][h]; // Temp array for random pixels
    for (int i = 0; i < w; i++)
    {
        for (int j = 0; j < h; j++)
        {
            int valr = int(random(255));
            int valg = int(random(255));
            int valb = int(random(255));
            p[i][j] = color(valr, valg, valb);
        }
    }
    return p;
}

color[][] MakeShift(color[][] p, int shift) // https://stackoverflow.com/a/34277492
{
    color[][] temp = p;
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
    return temp;
}

int[][] MakeNotMask(int w, int h)
{
    int[][] p = new int[w][h];
    for (int i = 0; i < w; i++) // y, height, row, etc. 
    {
        for (int j = 0; j < h; j++) // x, width, column, etc.
        {
            if (isOdd(i)) // Odd row
            {
                int val = j % 2; // 0, 1, 0, 1, ...
                p[i][j] = val;
            }
            else if (isEven(i)) // Even row
            {
                int val = -(j % 2) + 1; // 1, 0, 1, 0, ...
                p[i][j] = val;
            }
        }
    }
    return p;
}

color[][] MakeHalfPixels(color[][] p, int[][] m, int w, int h)
{
    color[][] hp = new color[w / 2][h / 2];
    for (int i = 0; i < w; i++) // Go through mask
    {
        for (int j = 0; j < h; j++)
        {
            if (m[i][j] == 1) // If can see through mask
            {
                int i_index = i / 2; // Transform mask index to pixel index
                int j_index = j / 2; // Transform mask index to pixel index
                hp[i_index][j_index] = p[i][j];
            }
        }
    }
    return hp;
}

color[][] MakeTextureFromImage(PImage im, int w, int h, boolean gray)
{
    color[][] pBuf = new color[w][h];
    im.loadPixels();
    
    if (gray)
    {
    for (int i = 0; i < (im.pixels.length / w); i++) 
    {
        for (int j = 0; j < (im.pixels.length / h); j++)
        {
            int pixelIndex = Convert2dTo1d(i, j, w);
            int a = im.pixels[pixelIndex] >> 16 * 0 & 0xFF; // Extract alpha component
            int r = im.pixels[pixelIndex] >> 16 * 1 & 0xFF; // Extract red component
            int g = im.pixels[pixelIndex] >> 16 * 2 & 0xFF; // Extract green component
            int b = im.pixels[pixelIndex] >> 16 * 3 & 0xFF; // Extract blue component
            int average = int((r + g + b) / 3);
            pBuf[i][j] = color(average);
        }
    }
    }
    else
    {
        for (int i = 0; i < (w); i++) 
        {
            for (int j = 0; j < (h); j++)
            {
                int pixelIndex = Convert2dTo1d(i, j, w);
                pBuf[i][j] = im.pixels[pixelIndex];
            }
        }
    }
    return pBuf;
}
