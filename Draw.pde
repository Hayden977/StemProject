void DrawRaw(color[][] p, int w, int h)
{
    for (int i = 0; i < w; i++) 
    {
        for (int j = 0; j < h; j++)
        {
        fill(p[i][j]);
        rect(i * psize, j * psize, psize, psize);
        }
    }
}

void DrawFilterLast(color[][] p, int[][] m, int w, int h) 
{
    for (int i = 0; i < w; i++) 
    {
        for (int j = 0; j < h; j++)
        {
        if (m[i][j] == 1) 
        {
            fill(p[i][j]);
            rect(i * psize, j * psize, psize, psize);
        }    
        }
    }
}

void DrawFilterFirst(color[][] p, int[][] m, int w, int h)
{
    for (int i = 0; i < w; i++)
    {
        for (int j = 0; j < h; j++)
        {
            if (m[i][j] == 1)
            {
                fill(p[i][j]);
                rect(i * psize, j * psize, psize, psize);
            }
        }
    }
}

void DrawInterlace(color[][] p, int w, int h)
{
    if (isEven(frameCount)) // Check if on even frame
    {
        for (int i = 0; i < w; i++)
        {
            for (int j = 0; j < h; j++)
            {
                if (isEven(j)) // Draw even lines
                {
                    fill(p[i][j]);
                    rect(i * psize, j * psize, psize, psize);
                }
            }
        }
    }
    else // Check if on odd frame (not even)
    {
        for (int i = 0; i < w; i++)
        {
            for (int j = 0; j < h; j++)
            {
                if (isOdd(j)) // Draw odd lines
                {
                    fill(p[i][j]);
                    rect(i * psize, j * psize, psize, psize);
                }
            }
        }
    }
}

void DrawHalfFilterLast(color[][] hp, int[][] m, int w, int h)
{
    for (int i = 0; i < w / 2; i++)
    {
        for (int j = 0; j < h / 2; j++)
        {
            int i_index = i * 2;
            int j_index = j * 2;
            if (m[i_index][j_index] == 1)
            {
                //int x = 2 * i;
                //int y = 2 * j;
                fill(hp[i][j]);
                rect(i_index * psize, j_index * psize, psize, psize);
            }
        }
    }
}

void DrawHalfFilterFirst(color[][] hp, int[][] m, int w, int h)
{
    for (int i = 0; i < w; i++)
    {
        for (int j = 0; j < h; j++)
        {
            if (m[i][j] == 1) //<>//
            {
                int i_hpindex = i / 2;
                int j_hpindex = j / 2;
                fill(hp[i_hpindex][j_hpindex]);
                rect(i * psize, j * psize, psize, psize);
            }
        }
    }
}
