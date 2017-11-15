module d2d.Renderer;

import derelict.sdl2.sdl;
import d2d.Texture;

/**
 * Renders objects to the window
 */
class Renderer {

    private SDL_Renderer* renderer;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Renderer* handle(){
        return this.renderer;
    }

    /**
     * Copies a texture to the window at the iven location
     */
    void copy(Texture texture, int x, int y){
        SDL_Rect drect = SDL_Rect(x, y, 0, 0);
        SDL_RenderCopy(this.renderer, texture.handle, null, &drect);
    }

    /**
     * Fills the screen with the given color
     */
    void fill(int r, int g, int b, int a=255){
        this.setColor(r, g, b, a);
        SDL_RenderClear(this.renderer);
    }

    /**
     * Fills the screen with the existing renderer color
     */
    void fill(){
        SDL_RenderClear(this.renderer);
    }

    /**
     * Sets the color of the renderer will draw with
     */
    void setColor(int r, int g, int b, int a=255){
        SDL_SetRenderDrawColor(this.renderer, cast(ubyte)r, cast(ubyte)g, cast(ubyte)b, cast(ubyte)a);
    }

}
