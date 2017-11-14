module d2d.Renderer;

import derelict.sdl2.sdl;
import d2d.Texture;

class Renderer {

    private SDL_Renderer* renderer;

    @property SDL_Renderer* handle(){
        return this.renderer;
    }

    void copy(Texture texture, int x, int y){
        SDL_Rect drect = SDL_Rect(x, y, 0, 0);
        SDL_RenderCopy(this.renderer, texture.handle, null, &drect);
    }

    void fill(int r, int g, int b, int a=255){
        this.setColor(r, g, b, a);
        SDL_RenderClear(this.renderer);
    }

    void fill(){
        SDL_RenderClear(this.renderer);
    }

    void setColor(int r, int g, int b, int a=255){
        SDL_SetRenderDrawColor(this.renderer, cast(ubyte)r, cast(ubyte)g, cast(ubyte)b, cast(ubyte)a);
    }

}