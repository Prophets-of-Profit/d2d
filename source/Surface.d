module d2d.Surface;

import derelict.sdl2.sdl;

/**
 * Surfaces are a rectangular collection of pixels
 * Surfaces are easy to work with and edit and can be blitted on to another surface
 * Surfaces can also be converted to textures which are more efficient but less flexible
 * Surfaces are handled in software as opposed to textures which are handled in hardware
 * Surfaces can be used, but when used repeatedly and stored, textures should be preferred
 */
class Surface {

    SDL_Surface* surface;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Surface* handle(){
        return this.surface;
    }

}
