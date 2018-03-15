module d2d.sdl2.Surface;

import std.algorithm;
import std.range;
import std.string;
import d2d.sdl2;

/**
 * Surfaces are a rectangular collection of pixels
 * Surfaces are easy to work with and edit and can be blitted on to another surface
 * Surfaces can also be converted to textures which are more efficient but less flexible
 * Surfaces are handled in software as opposed to textures which are handled in hardware
 * Surfaces can be used, but when used repeatedly and stored, textures should be preferred
 * Surface draw methods do not respect alpha, but surface blitting does; to draw with alpha, draw to another surface, and blit to desired surface
 */
class Surface {

    private SDL_Surface* surface;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Surface* handle() {
        return this.surface;
    }

    /**
     * Gets the surfaces dimensions as a vector with width as the x component and height as the y component
     */
    @property iVector dimensions() {
        return new iVector(this.surface.w, this.surface.h);
    }

    /**
     * Sets the alpha modifier for the surface
     * Alpha modification works by multiplying the alphaMultiplier / 255 into the surface pixels
     */
    @property void alphaMod(ubyte alphaMultiplier) {
        ensureSafe(SDL_SetSurfaceAlphaMod(this.surface, alphaMultiplier));
    }

    /**
     * Gets the alpha modifier for the surface
     * Alpha modification works by multiplying the alphaMultiplier / 255 into the surface pixels
     */
    @property ubyte alphaMod() {
        ubyte alphaMultiplier;
        ensureSafe(SDL_GetSurfaceAlphaMod(this.surface, &alphaMultiplier));
        return alphaMultiplier;
    }

    /**
     * Sets the surface's blend mode
     */
    @property void blendMode(SDL_BlendMode bMode) {
        ensureSafe(SDL_SetSurfaceBlendMode(this.surface, bMode));
    }

    /**
     * Gets the surface's blend mode
     */
    @property SDL_BlendMode blendMode() {
        SDL_BlendMode bMode;
        ensureSafe(SDL_GetSurfaceBlendMode(this.surface, &bMode));
        return bMode;
    }

    /**
     * Sets the clip boundaries for the surface
     * Anything put on the surface outside of the clip boundaries gets discarded
     */
    @property void clipRect(iRectangle clipArea) {
        ensureSafe(SDL_SetClipRect(this.surface, (clipArea is null) ? null : clipArea.handle));
    }

    /**
     * Gets the clip boundaries for the surface
     * Anything put on the surface outside of the clip boundaries gets discarded
     */
    @property iRectangle clipRect() {
        SDL_Rect clipArea;
        SDL_GetClipRect(this.surface, &clipArea);
        return new iRectangle(clipArea.x, clipArea.y, clipArea.w, clipArea.h);
    }

    /**
     * Sets the color modifier for the surface
     * Color modification works by multiplying the colorMultiplier / 255 into the surface pixels
     */
    @property void colorMod(Color colorMultiplier) {
        ensureSafe(SDL_SetSurfaceColorMod(this.surface, colorMultiplier.r,
                colorMultiplier.g, colorMultiplier.b));
    }

    /**
     * Gets the color modifier for the surface
     * Color modification works by multiplying the colorMultiplier / 255 into the surface pixels
     */
    @property Color colorMod() {
        Color colorMultiplier;
        ensureSafe(SDL_GetSurfaceColorMod(this.surface, &colorMultiplier.r,
                &colorMultiplier.g, &colorMultiplier.b));
        return colorMultiplier;
    }

    /**
     * Creates an RGB surface given at least a width and a height
     */
    this(int width, int height, int depth = 32, uint flags = 0, uint Rmask = 0,
            uint Gmask = 0, uint Bmask = 0, uint Amask = 0) {
        loadLibSDL();
        this.surface = ensureSafe(SDL_CreateRGBSurface(flags, width, height,
                depth, Rmask, Gmask, Bmask, Amask));
    }

    /**
     * Creates an RGB surface given at least a width, height, and an SDL_PixelFormatEnum
     */
    this(int width, int height, uint format, int depth = 32, uint flags = 0) {
        loadLibSDL();
        this.surface = ensureSafe(SDL_CreateRGBSurfaceWithFormat(flags, width,
                height, depth, format));
    }

    /**
     * Creates a surface from another surface but with a different pixel format
     */
    this(Surface src, SDL_PixelFormat* fmt, uint flags = 0) {
        loadLibSDL();
        this.surface = ensureSafe(SDL_ConvertSurface(src.handle, fmt, flags));
    }

    /**
     * Creates a surface from another surface but with a different pixel format
     */
    this(Surface src, uint fmt, uint flags = 0) {
        loadLibSDL();
        this.surface = ensureSafe(SDL_ConvertSurfaceFormat(src.handle, fmt, flags));
    }

    /**
     * Creates a surface from a BMP file path; for other image formats, use loadImage
     */
    this(string bmpFilePath) {
        loadLibSDL();
        this.surface = ensureSafe(SDL_LoadBMP(bmpFilePath.toStringz));
    }

    /**
     * Creates a surface from an already existing SDL_Surface
     */
    this(SDL_Surface* alreadyExisting) {
        this.surface = alreadyExisting;
    }

    /**
     * Ensures that SDL can properly dispose of the surface
     */
    ~this() {
        SDL_FreeSurface(this.surface);
    }

    /**
     * Saves the surface as a BMP with the given file name
     */
    void saveBMP(string fileName) {
        ensureSafe(SDL_SaveBMP(this.surface, fileName.toStringz));
    }

    /**
     * Blits another surface onto this surface
     * Takes the surface to blit, the slice of the surface to blit, and where on this surface to blit to
     * Is faster than a scaled blit to a rectangle
     */
    void blit(Surface src, iRectangle srcRect, int dstX, int dstY) {
        SDL_Rect dst = SDL_Rect(dstX, dstY, 0, 0);
        ensureSafe(SDL_BlitSurface(src.handle, (srcRect is null) ? null
                : srcRect.handle, this.surface, &dst));
    }

    /**
     * Does a scaled blit from another surface onto this surface
     * Takes the surface to blit, the slice of the surface to blit, and the slice on this surface of where to blit to
     * Is slower than the blit to a location
     */
    void blit(Surface src, iRectangle srcRect, iRectangle dstRect) {
        ensureSafe(SDL_BlitScaled(src.handle, (srcRect is null) ? null
                : srcRect.handle, this.surface, (dstRect is null) ? null : dstRect.handle));
    }

    /**
     * Fills a rectangle of the surface with the given color
     * Due to how SDL surfaces work, all other drawing functions on surface are built with this one
     */
    void fill(iRectangle destination, Color color) {
        ensureSafe(SDL_FillRect(this.surface, (destination is null) ? null
                : destination.handle, SDL_MapRGBA(this.surface.format, color.r,
                color.g, color.b, color.a)));
    }

    /**
     * Draws a point on the surface with the given color
     */
    void draw(int x, int y, Color color) {
        this.fill(new iRectangle(x, y, 1, 1), color);
    }

    /**
     * Draws a point on the surface with the given color
     */
    void draw(iVector point, Color color) {
        this.draw(point.x, point.y, color);
    }

    /**
     * Draws a line on the surface with the given color
     */
    void draw(iVector first, iVector second, Color color) {
        if (first.x == second.x) {
            this.fill(new iRectangle(first.x, first.y, 1, second.y - first.y), color);
        }
        else if (first.y == second.y) {
            this.fill(new iRectangle(first.x, first.y, second.x - first.x, 1), color);
        }
        else {
            foreach (x; iota(first.x, second.x, second.x > first.x ? 1 : -1)) {
                //Iterating through x and using point slope form
                immutable intersection = (second.y - first.y) / (second.x - first.x) * (
                        x - first.x) + first.y;
                this.draw(new iVector(x, intersection), color);
            }
        }
    }

    /**
     * Draws a line on the surface with the given color
     */
    void draw(iSegment line, Color color) {
        this.draw(line.initial, line.terminal, color);
    }

    /**
     * Draws a polygon on the surface with the given color
     */
    void draw(uint sides)(iPolygon!sides toDraw, Color color) {
        foreach (polygonSide; toDraw.sides) {
            this.draw(polygonSide, color);
        }
    }

    /**
     * Draws a rectangle on the surface
     */
    void draw(iRectangle rect, Color color) {
        this.draw!4(rect.toPolygon(), color);
    }

    /**
     * Draws the given bezier curve with numPoints number of points on the curve
     * More points is smoother but slower
     */
    void draw(uint numPoints = 100)(BezierCurve!(int, 2) curve, Color color) {
        Vector!(int, 2)[] points = cast(Vector!(int, 2)[])(curve.getPoints!numPoints);
        foreach (i; 0 .. points.length - 1) {
            this.draw(new iSegment(points[i], points[i + 1]), color);
        }
    }

    /**
     * Fills a polygon on the surface with the given color
     */
    void fill(uint sides)(iPolygon!sides toDraw, Color color) {
        iRectangle bounds = bound(toDraw);
        int[][int] intersections; //Stores a list of x coordinates of intersections accessed by the y value
        foreach (polygonSide; toDraw.sides) {
            //TODO: do we need to iterate through each y in the bounds? could we bound each segment and iterate through each y in that bound?
            foreach (y; bounds.y .. bounds.bottomLeft.y) {
                //Checks that the y value exists within the segment
                if ((y - polygonSide.initial.y) * (y - polygonSide.terminal.y) > 0) {
                    continue;
                }
                //If the segment is a horizontal line at this y, draws the horizontal line and then breaks
                if (y == polygonSide.initial.y && polygonSide.initial.y == polygonSide.terminal.y) {
                    this.drawLine(polygonSide.initial, polygonSide.terminal, color);
                    continue;
                }
                //Vertical lines
                if (polygonSide.initial.x == polygonSide.terminal.x) {
                    intersections[y] ~= polygonSide.initial.x;
                    continue;
                }
                //TODO: explain; the genius Saurabh Totey worked this out but has difficulty explaining how he got this math
                iVector sideDirection = polygonSide.direction;
                immutable dy = y - polygonSide.initial.y;
                intersections[y] ~= (dy * sideDirection.x + polygonSide.initial.x * sideDirection.y) / sideDirection
                    .y;

            }
        }
        foreach (y, xValues; intersections) {
            foreach (i; 0 .. xValues.sort.length - 1) {
                this.drawLine(new iVector(xValues[i], y), new iVector(xValues[i + 1], y), color);
            }
        }
    }

}

/**
 * Uses the SDL_Image library to create a non-bmp image surface
 */
Surface loadImage(string imagePath) {
    loadLibSDL();
    loadLibImage();
    return new Surface(ensureSafe(IMG_Load(imagePath.toStringz)));
}

/**
 * Returns a surface that fits the given rectangle
 * Fits the original surface within the returned surface to be as large as it can while maintaining aspect ratio
 * Also centers the original surface within the returned surface
 */
Surface scaled(Surface original, int desiredW, int desiredH) {
    Surface scaledSurface = new Surface(desiredW, desiredH, SDL_PIXELFORMAT_RGBA32);
    iVector newDimensions = cast(iVector)(cast(dVector) original.dimensions * min(
            cast(double) desiredW / original.dimensions.x,
            cast(double) desiredH / original.dimensions.y));
    iRectangle newLoc = new iRectangle((desiredW - newDimensions.x) / 2,
            (desiredH - newDimensions.y) / 2, newDimensions.x, newDimensions.y);
    scaledSurface.blit(original, null, newLoc);
    return scaledSurface;
}
