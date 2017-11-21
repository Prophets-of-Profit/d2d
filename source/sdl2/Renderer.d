module d2d.sdl2.Renderer;

import std.conv;
import std.math;
import d2d.sdl2;

/**
 * Renderers are objects that handle drawing things such as textures or shapes
 * A renderer can be obtained from a window, and could be used to draw on the window
 * Renderers draw using buffers; when a renderer draws, it isn't visible to the screen until the present method is called
 * While most of these functions are ported directly off of LibSDL2, most of them have been renamed into standard OOP convention
 * Many SDL functions are now property methods (eg. SDL_SetRenderDrawColor => renderer.drawColor = ...)
 * All functions defined in renderer are based off of SDL functions and SDL documentation can be viewed as well
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
     * Sets the color of the renderer will draw with
     */
    @property void drawColor(Color color){
        SDL_SetRenderDrawColor(this.renderer, color.r, color.g, color.b, color.a);
    }

    /**
     * Returns the color that the renderer will draw with
     */
    @property Color drawColor(){
        Color color;
        SDL_GetRenderDrawColor(this.renderer, &color.r, &color.g, &color.b, &color.a);
        return color;
    }

    /**
     * Sets the renderer's draw blend mode that affects how the renderer draws
     */
    @property void drawBlendMode(SDL_BlendMode blendMode){
        SDL_SetRenderDrawBlendMode(this.renderer, blendMode);
    }

    /**
     * Gets the renderer's draw blend mode that affects how the renderer draws
     */
    @property SDL_BlendMode drawBlendMode(){
        SDL_BlendMode bMode;
        SDL_GetRenderDrawBlendMode(this.renderer, &bMode);
        return bMode;
    }

    /**
     * Sets the viewport of the renderer to the given rectangle
     */
    @property void viewport(iRectangle vPort){
        SDL_RenderSetViewport(this.renderer, vPort.handle);
    }

    /**
     * Gets the viewport of the renderer as a rectangle
     */
    @property iRectangle viewport(){
        SDL_Rect viewPort;
        SDL_RenderGetViewport(this.renderer, &viewPort);
        return new iRectangle(viewPort.x, viewPort.y, viewPort.w, viewPort.h);
    }

    /**
     * Sets the clip area for the renderer
     * Anything that is rendered outside of the clip area gets discarded
     */
    @property void clipRect(iRectangle clipArea){
        SDL_RenderSetClipRect(this.renderer, (clipArea is null)? null : clipArea.handle);
    }

    /**
     * Gets the clip area for the renderer
     * Anything that is rendered outside of the clip area gets discarded
     */
    @property iRectangle clipRect(){
        SDL_Rect clipArea;
        SDL_RenderGetClipRect(this.renderer, &clipArea);
        return new iRectangle(clipArea.x, clipArea.y, clipArea.w, clipArea.h);
    }

    /**
     * Sets the renderer's x and y scale to the given point's x and y values
     */
    @property void scale(fPoint scaling){
        SDL_RenderSetScale(this.renderer, scaling.x, scaling.y);
    }

    /**
     * Gets the renderer's x and y scale as a point with the scales as the x and y coordinates
     */
    @property fPoint scale(){
        fPoint scaling = new fPoint(1, 1);
        SDL_RenderGetScale(this.renderer, &scaling.x, &scaling.y);
        return scaling;
    }

    /**
     * Sets the renderer's logical size
     * Logical size works in that you only need to give coordinates for one specific resolution, and SDL will handle scaling that to the best resolution matching the logical size's aspect ratio
     */
    @property void logicalSize(iPoint dimensions){
        SDL_RenderSetLogicalSize(this.renderer, dimensions.x, dimensions.y);
    }

    /**
     * Gets the renderer's logical size
     * Logical size works in that you only need to give coordinates for one specific resolution, and SDL will handle scaling that to the best resolution matching the logical size's aspect ratio
     */
    @property iPoint logicalSize(){
        iPoint dimensions = new iPoint(0, 0);
        SDL_RenderGetLogicalSize(this.renderer, &dimensions.x, &dimensions.y);
        return dimensions;
    }

    /**
     * Gets the renderer's information and returns it as an SDL_RendererInfo struct
     */
    @property SDL_RendererInfo info(){
        SDL_RendererInfo information;
        SDL_GetRendererInfo(this.renderer, &information);
        return information;
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
    void copy(Texture texture, iPoint destination, iRectangle sourceRect = null){
        //TODO implement
    }

    /**
     * Copies a texture to the window at the given rectangle
     * If sourceRect is null, it will copy the entire texture, otherwise, it will copy the slice defined by sourceRect
     */
    void copy(Texture texture, iRectangle destinationRect, iRectangle sourceRect = null){
        SDL_RenderCopy(this.renderer, texture.handle, (sourceRect is null)? null : sourceRect.handle, destinationRect.handle);
    }

    /**
     * Copies a texture to the window at the given rectangle with the given angle
     * If sourceRect is null, it will copy the entire texture, otherwise, it will copy the slice defined by sourceRect
     * Angles are given in radians
     */
    void copy(Texture texture, iRectangle destinationRect, double angle, SDL_RendererFlip flip = SDL_FLIP_NONE, iPoint center = null, iRectangle sourceRect = null){
        SDL_RenderCopyEx(this.renderer, texture.handle, (sourceRect is null)? null : sourceRect.handle, destinationRect.handle, angle * PI / 180, (center is null)? null : center.handle, flip);
    }

    /**
     * Sets the renderer's color and clears the screen
     */
    void clear(Color color){
        this.drawColor = color;
        SDL_RenderClear(this.renderer);
    }

    /**
     * Fills the screen with the existing renderer color
     */
    void clear(){
        SDL_RenderClear(this.renderer);
    }

    /**
     * Draws a line between the given points
     */
    void drawLine(iPoint first, iPoint second){
        SDL_RenderDrawLine(this.renderer, first.x, first.y, second.x, second.y);
    }

    /**
     * Draws a point
     */
    void drawPoint(iPoint toDraw){
        SDL_RenderDrawPoint(this.renderer, toDraw.x, toDraw.y);
    }

    /**
     * Draws a rectangle
     */
    void drawRect(iRectangle toDraw){
        SDL_RenderDrawRect(this.renderer, toDraw.handle);
    }

    /**
     * Fills a rectangle in with the renderer's color
     */
    void fillRecct(iRectangle toFill){
        SDL_RenderFillRect(this.renderer, toFill.handle);
    }

    /**
     * Updates what the renderer has drawn by actually outputting or presenting it
     */
    void present(){
        SDL_RenderPresent(this.renderer);
        this.clear();
    }

}
