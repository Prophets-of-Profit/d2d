module d2d.sdl2.Surface;

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
     * Creates an RGB surface given at least a width and a height
     */
    this(int width, int height, int depth = 32, uint flags = 0, uint Rmask = 0,
            uint Gmask = 0, uint Bmask = 0, uint Amask = 0) {
        this.surface = ensureSafe(SDL_CreateRGBSurface(flags, width, height,
                depth, Rmask, Gmask, Bmask, Amask));
    }

    /**
     * Creates an RGB surface given at least a width, height, and an SDL_PixelFormat
     */
    this(int width, int height, uint format, int depth = 32, uint flags = 0) {
        this.surface = ensureSafe(SDL_CreateRGBSurfaceWithFormat(flags, width,
                height, depth, format));
    }

    /**
     * Ensures that SDL can properly dispose of the surface
     */
    ~this() {
        SDL_FreeSurface(this.surface);
    }

}
