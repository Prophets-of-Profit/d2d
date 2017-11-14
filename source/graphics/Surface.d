module d2d.graphics.Surface;

import derelict.sdl2.sdl;

class Surface {

    SDL_Surface* surface;

    @property SDL_Surface* getSDL(){
        return this.surface;
    }

}
