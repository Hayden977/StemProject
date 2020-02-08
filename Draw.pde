class Renderer //<>//
{

    int ps;
    boolean q, h;

    Renderer(int size, boolean quality, boolean half) 
    {
        ps = size;
        q = quality;
        h = half;
    }

    void Raw(Buffer p, int w, int h)
    {
        for (int y = 0; y < h; y++) 
        {
            for (int x = 0; x < w; x++)
            {
                fill(p.buffer[y][x]);
                rect(x * this.ps, y * this.ps, this.ps, this.ps);
            }
        }
    }

    void FilterLast(Buffer p, Buffer m, int w, int h) 
    {
        for (int y = 0; y < h; y++) 
        {
            for (int x = 0; x < w; x++)
            {
                if (m.buffer[y][x] == 1) 
                {
                    fill(p.buffer[y][x]);
                    rect(x * this.ps, y * this.ps, this.ps, this.ps);
                }
            }
        }
    }

    void FilterFirst(Buffer p, Buffer m, int w, int h)
    {
        for (int y = 0; y < h; y++)
        {
            for (int x = 0; x < w; x++)
            {
                if (m.buffer[y][x] == 1)
                {
                    fill(p.buffer[y][x]);
                    rect(x * this.ps, y * this.ps, this.ps, this.ps);
                }
            }
        }
    }

    void Interlace(Buffer p, int w, int h)
    {
        if (frameCount % 2 == 0) // Check if on even frame
        {
            for (int y = 0; y < h / 2; y++)
            {
                for (int x = 0; x < w; x++)
                {
                    fill(p.buffer[y * 2][x]);
                    rect(x * this.ps, y * 2 * this.ps, this.ps, this.ps);
                }
            }
        } else // Check if on odd frame (not even)
        {
            for (int y = 0; y < h / 2; y++)
            {
                for (int x = 0; x < w; x++)
                {
                    fill(p.buffer[y * 2 + 1][x]);
                    rect(x * this.ps, y * 2 * this.ps +  this.ps, this.ps, this.ps);
                }
            }
        }
    }

    void HalfFilterLast(Buffer hp, Buffer m, int w, int h)
    {
        for (int y = 0; y < h / 2; y++)
        {
            for (int x = 0; x < w / 2; x++)
            {
                int x_index = x * 2;
                int y_index = y * 2;
                if (m.buffer[y_index][x_index] == 1)
                {
                    //int x = 2 * i;
                    //int y = 2 * j;
                    fill(hp.buffer[y][x]);
                    rect(x_index * this.ps, y_index * this.ps, this.ps, this.ps);
                }
            }
        }
    }

    void HalfFilterFirst(Buffer hp, Buffer m, int w, int h)
    {
        for (int y = 0; y < h; y++)
        {
            for (int x = 0; x < w; x++)
            {
                if (m.buffer[y][x] == 1)
                {
                    int x_hpindex = x / 2;
                    int y_hpindex = y / 2;
                    fill(hp.buffer[y_hpindex][x_hpindex]);
                    rect(x * this.ps, y * this.ps, this.ps, this.ps);
                }
            }
        }
    }
}
