/**
 * Surface
 */
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
class Surface : ShapeDrawer {

    private SDL_Surface* surface;
    private Color _drawColor = PredefinedColor.BLACK; ///The color that the surface will draw with

    /**
     * Sets the drawcolor for this surface; what color things will be drawn with
     */
    override @property void drawColor(Color color) {
        this._drawColor = color;
    }

    /**
     * Gets the drawcolor for this surface; what color things will be drawn with
     */
    override @property Color drawColor() {
        return this.drawColor;
    }

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
     * Defines how the shape drawer draws points on a surface
     * Used for all other shape drawer functions
     */
    override void drawPoint(int x, int y) {
        ensureSafe(SDL_FillRect(this.surface, new iRectangle(x, y, 1, 1).handle, 
                SDL_MapRGBA(this.surface.format, this.drawColor.r,
                this.drawColor.g, this.drawColor.b, this.drawColor.a)));
    }

    /**
     * Fills in a rectangle
     * Uses the SDL functionality for better performance
     */
    override void fillRect(iRectangle rect) {
        ensureSafe(SDL_FillRect(this.surface, (rect is null) ? null
                : rect.handle, SDL_MapRGBA(this.surface.format, this.drawColor.r,
                this.drawColor.g, this.drawColor.b, this.drawColor.a)));
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
