module d2d.Texture;

import derelict.sdl2.sdl;
import d2d.Renderer;
import d2d.Surface;

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
