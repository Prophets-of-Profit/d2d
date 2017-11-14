module d2d.Surface;

import derelict.sdl2.sdl;

class Surface {

    SDL_Surface* surface;    

    @property SDL_Surface* handle(){
        return this.surface;
    }

}