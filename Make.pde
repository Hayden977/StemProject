int[] MakeRandom(int w, int h)
{
    final int _l = w * h; // Length of the new array
    int[] p = new int[_l]; // Temp array for random pixels
    for (int i = 0; i < _l; i++)
    {
        int val = int(random(255 / cmax));
        p[i] = val;
    }
    return p;
}

int[] MakeShift(int[] p)
{
    int[] temp = p;
    int _last = temp[temp.length - 1]; // Get the final value in array
    for (int j = temp.length - 1; j >= 1; j--) // Go through array backwards
    {
        temp[j] = temp[j - 1]; // Move each value one to the right
    }
    temp[0] = _last; // Add the last value to the front
    return temp;
}

int[] MakeNotMask(int w, int h)
{
    final int _l = w * h;
    int[] p = new int[_l];
    for (int i = 0; i < h; i++) // y, height, row, etc. 
    {
        for (int j = 0; j < w; j++) // x, width, column, etc.
        {
            if (i % 2 == 1) // Odd row
            {
                int val = j % 2; // 0, 1, 0, 1, ...
                int _index = w * i + j; // https://stackoverflow.com/a/2151141
                p[_index] = val;
            }
            else if (i % 2 == 0) // Even row
            {
                int val = -(j % 2) + 1; // 1, 0, 1, 0, ...
                int _index = w * i + j; // https://stackoverflow.com/a/2151141
                p[_index] = val;
            }
        }
    }
    return p;
}

int[] MakeHalfPixels(int[] p, int[] m, int w, int h)
{
    final int _l = (w * h) / 2;
    int[] hp = new int[_l];
    for (int i = 0; i < m.length; i++) // Go through mask
    {
        if (m[i] == 1) // If can see through mask
        {
            int _index = i / 2; // Transform mask index to pixel index
            hp[_index] = p[i];
        }
    }
    return hp;
}
