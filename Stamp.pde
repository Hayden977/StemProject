color[][] StampRect(color[][] p, int rx, int ry, int rw, int rh, color c) //<>//
{
    color[][] temp = p;
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
            temp[i][j] = c;
        }
    }
    return temp;
}

color[][] StampImage(color[][] p, int rx, int ry, color[][] im, int iw, int ih)
{
    color[][] temp = p;
    int xMin = rx, xMax = rx + iw;
    int yMin = ry, yMax = ry + ih;
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
            temp[i][j] = im[im_x][im_y];
        }
    }
    return temp; //<>//
}
