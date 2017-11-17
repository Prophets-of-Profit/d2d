module d2d.Renderer;

import derelict.sdl2.sdl;
import d2d.Texture;

/**
 * Renderers are objects that handle drawing things such as textures or shapes
 * A renderer can be obtained from a window, and could be used to draw on the window
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
     * Copies a texture to the window at the given rectangle
     * TODO use a rectangle struct as an input for this
     */
    void copy(Texture texture){
        SDL_RenderCopy(this.renderer, texture.handle, null, null);
    }

    /**
     * Fills the screen with the given color
     * TODO take in a color struct instead for this
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
     * TODO take in a clor struct instead for this
     */
    void setColor(int r, int g, int b, int a=255){
        SDL_SetRenderDrawColor(this.renderer, cast(ubyte)r, cast(ubyte)g, cast(ubyte)b, cast(ubyte)a);
    }

}
