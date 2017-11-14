module d2d.Texture;

import derelict.sdl2.sdl;
import d2d.Renderer;
import d2d.Surface;

class Texture {

    private SDL_Texture* texture;

    @property SDL_Texture* handle(){
        return this.texture;
    }

    this(Surface surface, Renderer renderer){
        SDL_CreateTextureFromSurface(renderer.handle, surface.handle);
    }

}
