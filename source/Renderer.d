module d2d.Renderer;

public import d2d.Utility;

import std.conv;
import derelict.sdl2.sdl;
import d2d.Texture;
import d2d.Window;

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
     * Makes an SDL renderer
     * A window already comes paired with a renderer, but this constructor may be called to make more renderers
     */
    this(Window window, uint flags = 0){
        this.renderer = SDL_CreateRenderer(window.handle, -1, flags.to!SDL_RendererFlags);
    }

    /**
     * Ensures that SDL can properly dispose of the renderer
     */
    ~this(){
        SDL_DestroyRenderer(this.renderer);
    }

    /**
     * Copies a texture to the window at the given point
     * Uses the dimensions of the given sourceRect or if not given, the dimensions of the original texture
     */
    void copy(Texture texture, iPoint destination, Rectangle sourceRect = null){
        //TODO implement
    }

    /**
     * Copies a texture to the window at the given rectangle
     * If sourceRect is null, it will copy the entire texture, otherwise, it will copy the slice defined by sourceRect
     */
    void copy(Texture texture, Rectangle destinationRect, Rectangle sourceRect = null){
        const SDL_Rect srcRect = sourceRect.handle;
        const SDL_Rect dstRect = destinationRect.handle;
        SDL_RenderCopy(this.renderer, texture.handle, &srcRect, &dstRect);
    }

    /**
     * Sets the renderer's color and clears the screen
     */
    void clear(Color color){
        this.setDrawColor(color);
        SDL_RenderClear(this.renderer);
    }

    /**
     * Fills the screen with the existing renderer color
     */
    void clear(){
        SDL_RenderClear(this.renderer);
    }

    /**
     * Sets the color of the renderer will draw with
     */
    void setDrawColor(Color color){
        SDL_SetRenderDrawColor(this.renderer, color.r, color.g, color.b, color.a);
    }

}
