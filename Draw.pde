void DrawRaw(int[] _p, int w, int h)
{
    for (int i = 0; i < _p.length; i++) 
    {
        int px = i % w;
        int py = i / h;
        fill(_p[i] * cmax);
        rect(px * psize, py * psize, psize, psize);
    }
}

void DrawFilterLast(int[] _p, int[] _m, int w, int h) 
{
    for (int i = 0; i < _p.length; i++) 
    {
        if (_m[i] == 1) 
        {
            int px = i % w;
            int py = i / h;
            fill(_p[i] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }    
    }
}

void DrawFilterFirst(int[] _p, int[] _m, int w, int h)
{
    for (int i = 0; i < _m.length; i++)
    {
        if (_m[i] == 1)
        {
            int px = i % w;
            int py = i / h;
            fill(_p[i] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }
    }
}

void DrawInterlace(int[] _p, int w, int h)
{
    if (frameCount % 2 == 0) // Check if on even frame
    {
        for (int i = 0; i < _p.length; i++)
        {
            if ((i / h) % 2 == 0) // Draw even lines
            {
                int px = i % w;
                int py = i / h;
                fill(_p[i] * cmax);
                rect(px * psize, py * psize, psize, psize);
            }
        }
    }
    else // Check if on odd frame (not even)
    {
        for (int i = 0; i < _p.length; i++) // Draw odd lines
        {
            if ((i / h) % 2 == 1)
            {
                int px = i % w;
                int py = i / h;
                fill(_p[i] * cmax);
                rect(px * psize, py * psize, psize, psize);
            }
        }
    }
}

void DrawHalfFilterLast(int[] _hp, int[] _m, int w, int h)
{
    for (int i = 0; i < _hp.length; i++)
    {
        int _mindex = i * 2;
        if (_m[_mindex] == 1)
        {
            int px = 2 * (i % w);
            int py = 2 * (i / h);
            fill(_hp[i] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }
    }
}

void DrawHalfFilterFirst(int[] _hp, int[] _m, int w, int h)
{
    for (int i = 0; i < _m.length; i++)
    {
        if (_m[i] == 1)
        {
            int _hpindex = i / 2;
            int px = (i % w);
            int py = (i / h);
            fill(_hp[_hpindex] * cmax);
            rect(px * psize, py * psize, psize, psize);
        }
    }
}
