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
        if (!this.q) {
            return;
        } // High quality
        if (this.h) {
            return;
        } // Full
        for (int i = 0; i < w; i++) 
        {
            for (int j = 0; j < h; j++)
            {
                fill(p.buffer[i][j]);
                rect(i * this.ps, j * this.ps, this.ps, this.ps);
            }
        }
    }

    void FilterLast(Buffer p, Buffer m, int w, int h) 
    {
        if (this.q) {
            return;
        } // Low quality
        if (this.h) {
            return;
        } // Full
        for (int i = 0; i < w; i++) 
        {
            for (int j = 0; j < h; j++)
            {
                if (m.buffer[i][j] == 1) 
                {
                    fill(p.buffer[i][j]);
                    rect(i * this.ps, j * this.ps, this.ps, this.ps);
                }
            }
        }
    }

    void FilterFirst(Buffer p, Buffer m, int w, int h)
    {
        if (!this.q) {
            return;
        } // High quality
        if (this.h) {
            return;
        } // Full
        for (int i = 0; i < w; i++)
        {
            for (int j = 0; j < h; j++)
            {
                if (m.buffer[i][j] == 1)
                {
                    fill(p.buffer[i][j]);
                    rect(i * this.ps, j * this.ps, this.ps, this.ps);
                }
            }
        }
    }

    void Interlace(Buffer p, int w, int h)
    {
        if (!this.q) {
            return;
        } // High quality
        if (this.h) {
            return;
        } // Full
        if (frameCount % 2 == 0) // Check if on even frame
        {
            for (int i = 0; i < w; i++)
            {
                for (int j = 0; j < h; j++)
                {
                    if (j % 2 == 0) // Draw even lines
                    {
                        fill(p.buffer[i][j]);
                        rect(i * this.ps, j * this.ps, this.ps, this.ps);
                    }
                }
            }
        } else // Check if on odd frame (not even)
        {
            for (int i = 0; i < w; i++)
            {
                for (int j = 0; j < h; j++)
                {
                    if (j % 2 == 1) // Draw odd lines
                    {
                        fill(p.buffer[i][j]);
                        rect(i * this.ps, j * this.ps, this.ps, this.ps);
                    }
                }
            }
        }
    }

    void HalfFilterLast(Buffer hp, Buffer m, int w, int h)
    {
        if (this.q) {
            return;
        } // Low quality
        if (!this.h) {
            return;
        } // Half
        for (int i = 0; i < w / 2; i++)
        {
            for (int j = 0; j < h / 2; j++)
            {
                int i_index = i * 2;
                int j_index = j * 2;
                if (m.buffer[i_index][j_index] == 1)
                {
                    //int x = 2 * i;
                    //int y = 2 * j;
                    fill(hp.buffer[i][j]);
                    rect(i_index * this.ps, j_index * this.ps, this.ps, this.ps);
                }
            }
        }
    }

    void HalfFilterFirst(Buffer hp, Buffer m, int w, int h)
    {
        if (!this.q) {
            return;
        } // High quality
        if (!this.h) {
            return;
        } // Half
        for (int i = 0; i < w; i++)
        {
            for (int j = 0; j < h; j++)
            {
                if (m.buffer[i][j] == 1)
                {
                    int i_hpindex = i / 2;
                    int j_hpindex = j / 2;
                    fill(hp.buffer[i_hpindex][j_hpindex]);
                    rect(i * this.ps, j * this.ps, this.ps, this.ps);
                }
            }
        }
    }
}
