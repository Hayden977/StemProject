int[] Convert1dTo2d(int index, int w, int h)
{
    int[] temp = new int[2];
    temp[0] = index % w; // X
    temp[1] = index / h; // Y
    return temp;
}

int Convert2dTo1d(int x, int y, int w)
{
    int rowOffset = y * w;
    int xOffset = x;
    return rowOffset + xOffset;
}

boolean isEven(int value)
{
    if (value % 2 == 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

boolean isOdd(int value)
{
    if (value % 2 == 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}
