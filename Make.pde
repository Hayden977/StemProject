int[] MakeRandom(int w, int h)
{
    final int _l = w * h; // Length of the new array
    int[] _p = new int[_l]; // Temp array for random pixels
    for (int i = 0; i < _l; i++)
    {
        int val = int(random(255 / cmax));
        _p[i] = val;
    }
    return _p;
}

int[] MakeShift(int[] _p)
{
    int[] _temp = _p;
    int last = _temp[_temp.length - 1]; // Get the final value in array
    for (int j = _temp.length - 1; j >= 1; j--) // Go through array backwards
    {
        _temp[j] = _temp[j - 1]; // Move each value one to the right
    }
    _temp[0] = last; // Add the last value to the front
    return _temp;
}

int[] MakeNotMask(int w, int h)
{
    final int _l = w * h;
    int[] _p = new int[_l];
    for (int i = 0; i < h; i++) // y, height, row, etc. 
    {
        for (int j = 0; j < w; j++) // x, width, column, etc.
        {
            if (i % 2 == 1) // Odd row
            {
                int val = j % 2; // 0, 1, 0, 1, ...
                int index = w * i + j; // https://stackoverflow.com/a/2151141
                _p[index] = val;
            }
            else if (i % 2 == 0) // Even row
            {
                int val = -(j % 2) + 1; // 1, 0, 1, 0, ...
                int index = w * i + j; // https://stackoverflow.com/a/2151141
                _p[index] = val;
            }
        }
    }
    return _p;
}

int[] MakeHalfPixels(int[] _p, int[] _m, int w, int h)
{
    final int _l = (w * h) / 2;
    int[] _hp = new int[_l];
    for (int i = 0; i < _m.length; i++) // Go through mask
    {
        if (_m[i] == 1) // If can see through mask
        {
            int _convert = i / 2; // Transform mask index to pixel index
            _hp[_convert] = _p[i];
        }
    }
    return _hp;
}
