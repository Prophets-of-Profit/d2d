module d2d.graphics.Texture;

import d2d.graphics.Surface;
import d2d.graphics.Renderer;

import derelict.sdl2.sdl;

class Texture {

    SDL_Texture* texture;

    this(Surface surface, Renderer renderer){
        SDL_CreateTextureFromSurface(renderer.getSDL, surface.getSDL);
    }

    @property SDL_Texture* getSDL(){
        return this.texture;
    }

}
