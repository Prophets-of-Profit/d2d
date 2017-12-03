module d2d.sdl2.Surface;

import std.string;
public import d2d.sdl2;

/**
 * Surfaces are a rectangular collection of pixels
 * Surfaces are easy to work with and edit and can be blitted on to another surface
 * Surfaces can also be converted to textures which are more efficient but less flexible
 * Surfaces are handled in software as opposed to textures which are handled in hardware
 * Surfaces can be used, but when used repeatedly and stored, textures should be preferred
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
        loadSDL();
        this.surface = ensureSafe(SDL_CreateRGBSurface(flags, width, height,
                depth, Rmask, Gmask, Bmask, Amask));
    }

    /**
     * Creates an RGB surface given at least a width, height, and an SDL_PixelFormatEnum
     */
    this(int width, int height, uint format, int depth = 32, uint flags = 0) {
        loadSDL();
        this.surface = ensureSafe(SDL_CreateRGBSurfaceWithFormat(flags, width,
                height, depth, format));
    }

    /**
     * Creates a surface from another surface but with a different pixel format
     */
    this(Surface src, SDL_PixelFormat* fmt, uint flags = 0) {
        loadSDL();
        this.surface = ensureSafe(SDL_ConvertSurface(src.handle, fmt, flags));
    }

    /**
     * Creates a surface from another surface but with a different pixel format
     */
    this(Surface src, uint fmt, uint flags = 0) {
        loadSDL();
        this.surface = ensureSafe(SDL_ConvertSurfaceFormat(src.handle, fmt, flags));
    }

    /**
     * Creates a surface from a BMP file path; for other image formats, use loadImage
     */
    this(string bmpFilePath) {
        loadSDL();
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
     * Blits another surface onto this surface
     * Takes the surface to blit, the slice of the surface to blit, and where on this surface to blit to
     * Is faster than a scaled blit to a rectangle
     */
    void blit(Surface src, iRectangle srcRect, iPoint dstLocation) {
        SDL_Rect dst = SDL_Rect(dstLocation.x, dstLocation.y, 0, 0);
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
     */
    void fillRect(iRectangle destination, Color color) {
        ensureSafe(SDL_FillRect(this.surface, (destination is null) ? null
                : destination.handle, SDL_MapRGBA(this.surface.format, color.r,
                color.g, color.b, color.a)));
    }

}

/**
 * Uses the SDL_Image library to create a non-bmp image surface
 */
Surface loadImage(string imagePath) {
    loadSDL();
    d2d.sdl2.loadImage();
    return new Surface(ensureSafe(IMG_Load(imagePath.toStringz)));
}

//TODO ttf stuff
