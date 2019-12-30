void DrawRaw(int[] p, int w, int h)
{
    for (int i = 0; i < p.length; i++) 
    {
        int px = i % w;
        int py = i / h;
        fill(p[i] * cmax);
        rect(px * psize, py * psize, psize, psize);
    }
}

void DrawFilterLast(int[] p, int[] m, int w, int h) 
{
    for (int i = 0; i < p.length; i++) 
    {
        if (m[i] == 1) 
        {
            int px = i % w;
            int py = i / h;
            fill(p[i] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }    
    }
}

void DrawFilterFirst(int[] p, int[] m, int w, int h)
{
    for (int i = 0; i < m.length; i++)
    {
        if (m[i] == 1)
        {
            int px = i % w;
            int py = i / h;
            fill(p[i] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }
    }
}

void DrawInterlace(int[] p, int w, int h)
{
    if (frameCount % 2 == 0) // Check if on even frame
    {
        for (int i = 0; i < p.length; i++)
        {
            if ((i / h) % 2 == 0) // Draw even lines
            {
                int px = i % w;
                int py = i / h;
                fill(p[i] * cmax);
                rect(px * psize, py * psize, psize, psize);
            }
        }
    }
    else // Check if on odd frame (not even)
    {
        for (int i = 0; i < p.length; i++) // Draw odd lines
        {
            if ((i / h) % 2 == 1)
            {
                int px = i % w;
                int py = i / h;
                fill(p[i] * cmax);
                rect(px * psize, py * psize, psize, psize);
            }
        }
    }
}

void DrawHalfFilterLast(int[] hp, int[] m, int w, int h)
{
    for (int i = 0; i < hp.length; i++)
    {
        int _mindex = i * 2;
        if (m[_mindex] == 1)
        {
            int px = 2 * (i % w);
            int py = 2 * (i / h);
            fill(hp[i] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }
    }
}

void DrawHalfFilterFirst(int[] hp, int[] m, int w, int h)
{
    for (int i = 0; i < m.length; i++)
    {
        if (m[i] == 1)
        {
            int _hpindex = i / 2;
            int px = (i % w);
            int py = (i / h);
            fill(hp[_hpindex] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }
    }
}
