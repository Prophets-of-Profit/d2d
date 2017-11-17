module d2d.Texture;

import derelict.sdl2.sdl;
import d2d.Renderer;
import d2d.Surface;

/**
 * Textures are a rectangular collection of pixels
 * Textures are fast and can be drawn using a renderer
 * Textures can be created from a more easily edited surface
 * Textures are handled in hardware as opposed to surfaces which are handled in software
 * When used repeatedly and stored, textures should be preferred, but surfaces should be used when flexibility is desired
 */
class Texture {

    private SDL_Texture* texture;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Texture* handle(){
        return this.texture;
    }

    /**
     * Constructs a new texture from a surface
     */
    this(Surface surface, Renderer renderer){
        SDL_CreateTextureFromSurface(renderer.handle, surface.handle);
    }

}
