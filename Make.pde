color[][] MakeHalfPixels(Buffer p, Buffer m, int w, int h)
{
    color[][] hp = new color[w / 2][h / 2];
    for (int i = 0; i < w; i++) // Go through mask
    {
        for (int j = 0; j < h; j++)
        {
            if (m.buffer[i][j] == 1) // If can see through mask
            {
                int i_index = i / 2; // Transform mask index to pixel index
                int j_index = j / 2; // Transform mask index to pixel index
                hp[i_index][j_index] = p.buffer[i][j];
            }
        }
    }
    return hp;
}
