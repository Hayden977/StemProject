void DrawRaw(Buffer p, int w, int h)
{
    for (int i = 0; i < w; i++) 
    {
        for (int j = 0; j < h; j++)
        {
        fill(p.buffer[i][j]);
        rect(i * psize, j * psize, psize, psize);
        }
    }
}

void DrawFilterLast(Buffer p, Buffer m, int w, int h) 
{
    for (int i = 0; i < w; i++) 
    {
        for (int j = 0; j < h; j++)
        {
        if (m.buffer[i][j] == 1) 
        {
            fill(p.buffer[i][j]);
            rect(i * psize, j * psize, psize, psize);
        }    
        }
    }
}

void DrawFilterFirst(Buffer p, Buffer m, int w, int h)
{
    for (int i = 0; i < w; i++)
    {
        for (int j = 0; j < h; j++)
        {
            if (m.buffer[i][j] == 1)
            {
                fill(p.buffer[i][j]);
                rect(i * psize, j * psize, psize, psize);
            }
        }
    }
}

void DrawInterlace(Buffer p, int w, int h)
{
    if (isEven(frameCount)) // Check if on even frame
    {
        for (int i = 0; i < w; i++)
        {
            for (int j = 0; j < h; j++)
            {
                if (isEven(j)) // Draw even lines
                {
                    fill(p.buffer[i][j]);
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
                    fill(p.buffer[i][j]);
                    rect(i * psize, j * psize, psize, psize);
                }
            }
        }
    }
}

void DrawHalfFilterLast(Buffer hp, Buffer m, int w, int h)
{
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
                rect(i_index * psize, j_index * psize, psize, psize);
            }
        }
    }
}

void DrawHalfFilterFirst(Buffer hp, Buffer m, int w, int h)
{
    for (int i = 0; i < w; i++)
    {
        for (int j = 0; j < h; j++)
        {
            if (m.buffer[i][j] == 1) //<>//
            {
                int i_hpindex = i / 2;
                int j_hpindex = j / 2;
                fill(hp.buffer[i_hpindex][j_hpindex]);
                rect(i * psize, j * psize, psize, psize);
            }
        }
    }
}
