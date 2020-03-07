class Renderer //<>// //<>//
{
    Renderer() 
    {
        println("Initialized Renderer" + this.toString());
    }

    void Raw(PixelBuffer p, int w, int h)
    {
        for (int y = 0; y < h; y++) 
            for (int x = 0; x < w; x++)
                set(x, y, p.buffer[y][x]);
    }

    void FilterLast(PixelBuffer p, MaskBuffer m, int w, int h) 
    {
        for (int y = 0; y < h; y++) 
            for (int x = 0; x < w; x++)
                if (m.buffer[y][x] != m.transparent) 
                    set(x, y, p.buffer[y][x]);
    }

    void FilterFirst(PixelBuffer p, MaskBuffer m, int w, int h)
    {
        for (int y = 0; y < h; y++)
            for (int x = 0; x < w; x++)
                if (m.buffer[y][x] != m.transparent)
                    set(x, y, p.buffer[y][x]);
    }

    void Interlace(PixelBuffer p, int w, int h)
    {
        if (frameCount % 2 == 0) // Check if on even frame
            for (int y = 0; y < h / 2; y++)
                for (int x = 0; x < w; x++)
                    set(x, y * 2, p.buffer[y * 2][x]);
        else // Check if on odd frame (not even)
        for (int y = 0; y < h / 2; y++)
            for (int x = 0; x < w; x++)
                set(x, y * 2 + 1, p.buffer[y * 2 + 1][x]);
    }

    void CompressedFilterLast(CompressedPixelBuffer cp, MaskBuffer m, int w, int h)
    {
        for (int y = 0; y < h / cp.comp; y++)
            for (int x = 0; x < w / cp.comp; x++)
                if (m.buffer[y * cp.comp][x * cp.comp] != m.transparent)
                    set(x * cp.comp, y * cp.comp, cp.buffer[y][x]);
    }

    void CompressedFilterFirst(CompressedPixelBuffer cp, MaskBuffer m, int w, int h)
    {
        for (int y = 0; y < h; y++)
            for (int x = 0; x < w; x++)
                if (m.buffer[y][x] != m.transparent)
                    set(x, y, cp.buffer[y / cp.comp][x / cp.comp]);
    }
}
