void DrawRaw(color[] p, int w, int h)
{
    for (int i = 0; i < p.length; i++) 
    {
        int[] coords = Convert1dTo2d(i, w, h);
        fill(p[i]);
        rect(coords[0] * psize, coords[1] * psize, psize, psize);
    }
}

void DrawFilterLast(color[] p, int[] m, int w, int h) 
{
    for (int i = 0; i < p.length; i++) 
    {
        if (m[i] == 1) 
        {
            int[] coords = Convert1dTo2d(i, w, h);
            fill(p[i]);
            rect(coords[0] * psize, coords[1] * psize, psize, psize);
        }    
    }
}

void DrawFilterFirst(color[] p, int[] m, int w, int h)
{
    for (int i = 0; i < m.length; i++)
    {
        if (m[i] == 1)
        {
            int[] coords = Convert1dTo2d(i, w, h);
            fill(p[i]);
            rect(coords[0] * psize, coords[1] * psize, psize, psize);
        }
    }
}

void DrawInterlace(color[] p, int w, int h)
{
    if (isEven(frameCount)) // Check if on even frame
    {
        for (int i = 0; i < p.length; i++)
        {
            if (isEven(i / h)) // Draw even lines
            {
                int[] coords = Convert1dTo2d(i, w, h);
                fill(p[i]);
                rect(coords[0] * psize, coords[1] * psize, psize, psize);
            }
        }
    }
    else // Check if on odd frame (not even)
    {
        for (int i = 0; i < p.length; i++) // Draw odd lines
        {
            if (isOdd(i / h))
            {
                int[] coords = Convert1dTo2d(i, w, h);
                fill(p[i]);
                rect(coords[0] * psize, coords[1] * psize, psize, psize);
            }
        }
    }
}

void DrawHalfFilterLast(color[] hp, int[] m, int w, int h)
{
    for (int i = 0; i < hp.length; i++)
    {
        int _mindex = i * 2;
        if (m[_mindex] == 1)
        {
            int[] coords = Convert1dTo2d(i, w, h);
            coords[0] = 2 * coords[0];
            coords[1] = 2 * coords[1];
            fill(hp[i]);
            rect(coords[0] * psize, coords[1] * psize, psize, psize);
        }
    }
}

void DrawHalfFilterFirst(color[] hp, int[] m, int w, int h)
{
    for (int i = 0; i < m.length; i++)
    {
        if (m[i] == 1)
        {
            int _hpindex = i / 2;
            int[] coords = Convert1dTo2d(i, w, h);
            fill(hp[_hpindex]);
            rect(coords[0] * psize, coords[1] * psize, psize, psize);
        }
    }
}
