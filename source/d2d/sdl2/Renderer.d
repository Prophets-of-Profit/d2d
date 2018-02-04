module d2d.sdl2.Renderer;

import std.algorithm;
import std.math;
import d2d.sdl2;

/**
 * Renderers are objects that handle drawing things such as textures or shapes
 * A renderer can be obtained from a window, and could be used to draw on the window
 * Renderers draw using buffers; when a renderer draws, it isn't visible to the screen until the present method is called
 * While most of these functions are ported directly off of LibSDL2, most of them have been renamed into standard OOP convention
 * Many SDL functions are now property methods (eg. SDL_SetRenderDrawColor => renderer.drawColor = ...)
 * All functions defined in renderer are based off of SDL functions and SDL documentation can be viewed as well
 * TODO: implement curve drawing
 */
class Renderer {

    private SDL_Renderer* renderer;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Renderer* handle() {
        return this.renderer;
    }

    /**
     * Sets the color of the renderer will draw with
     */
    @property void drawColor(Color color) {
        ensureSafe(SDL_SetRenderDrawColor(this.renderer, color.r, color.g, color.b, color.a));
    }

    /**
     * Returns the color that the renderer will draw with
     */
    @property Color drawColor() {
        Color color;
        ensureSafe(SDL_GetRenderDrawColor(this.renderer, &color.r, &color.g,
                &color.b, &color.a));
        return color;
    }

    /**
     * Sets the renderer's draw blend mode that affects how the renderer draws
     */
    @property void drawBlendMode(SDL_BlendMode blendMode) {
        ensureSafe(SDL_SetRenderDrawBlendMode(this.renderer, blendMode));
    }

    /**
     * Gets the renderer's draw blend mode that affects how the renderer draws
     */
    @property SDL_BlendMode drawBlendMode() {
        SDL_BlendMode bMode;
        ensureSafe(SDL_GetRenderDrawBlendMode(this.renderer, &bMode));
        return bMode;
    }

    /**
     * Sets the viewport of the renderer to the given rectangle
     */
    @property void viewport(iRectangle vPort) {
        ensureSafe(SDL_RenderSetViewport(this.renderer, vPort.handle));
    }

    /**
     * Gets the viewport of the renderer as a rectangle
     */
    @property iRectangle viewport() {
        SDL_Rect viewPort;
        SDL_RenderGetViewport(this.renderer, &viewPort);
        return new iRectangle(viewPort.x, viewPort.y, viewPort.w, viewPort.h);
    }

    /**
     * Sets the clip area for the renderer
     * Anything that is rendered outside of the clip area gets discarded
     */
    @property void clipRect(iRectangle clipArea) {
        ensureSafe(SDL_RenderSetClipRect(this.renderer, (clipArea is null) ? null : clipArea.handle));
    }

    /**
     * Gets the clip area for the renderer
     * Anything that is rendered outside of the clip area gets discarded
     */
    @property iRectangle clipRect() {
        SDL_Rect clipArea;
        SDL_RenderGetClipRect(this.renderer, &clipArea);
        return (clipArea.w == 0 && clipArea.h == 0)? null : new iRectangle(clipArea.x, clipArea.y, clipArea.w, clipArea.h);
    }

    /**
     * Sets the renderer's x and y scale to the given point's x and y values
     */
    @property void scale(fVector scaling) {
        ensureSafe(SDL_RenderSetScale(this.renderer, scaling.x, scaling.y));
    }

    /**
     * Gets the renderer's x and y scale as a point with the scales as the x and y coordinates
     */
    @property fVector scale() {
        fVector scaling = new fVector(1, 1);
        ensureSafe(SDL_RenderGetScale(this.renderer, &scaling.x, &scaling.y));
        return scaling;
    }

    /**
     * Sets the renderer's logical size
     * Logical size works in that you only need to give coordinates for one specific resolution, and SDL will handle scaling that to the best resolution matching the logical size's aspect ratio
     */
    @property void logicalSize(iVector dimensions) {
        ensureSafe(SDL_RenderSetLogicalSize(this.renderer, dimensions.x, dimensions.y));
    }

    /**
     * Gets the renderer's logical size
     * Logical size works in that you only need to give coordinates for one specific resolution, and SDL will handle scaling that to the best resolution matching the logical size's aspect ratio
     */
    @property iVector logicalSize() {
        iVector dimensions = new iVector(0, 0);
        SDL_RenderGetLogicalSize(this.renderer, &dimensions.x, &dimensions.y);
        return dimensions;
    }

    /**
     * Gets the renderer's output size
     */
    @property iVector outputSize() {
        iVector size = new iVector(0, 0);
        ensureSafe(SDL_GetRendererOutputSize(this.renderer, &size.x, &size.y));
        return size;
    }

    /**
     * Gets the renderer's information and returns it as an SDL_RendererInfo struct
     */
    @property SDL_RendererInfo info() {
        SDL_RendererInfo information;
        ensureSafe(SDL_GetRendererInfo(this.renderer, &information));
        return information;
    }

    /**
     * Makes an SDL renderer for a window
     */
    this(Window window, uint flags = 0) {
        this.renderer = ensureSafe(SDL_CreateRenderer(window.handle, -1,
                cast(SDL_RendererFlags) flags));
    }

    /**
     * Makes a renderer from an already existing SDL_Renderer
     */
    this(SDL_Renderer* alreadyExisting) {
        this.renderer = alreadyExisting;
    }

    /**
     * Ensures that SDL can properly dispose of the renderer
     */
    ~this() {
        SDL_DestroyRenderer(this.renderer);
    }

    /**
     * Copies a texture to the window at the given point
     * Uses the dimensions of the given sourceRect or if not given, the dimensions of the original texture
     */
    void copy(Texture texture, iVector destination, iRectangle sourceRect = null) {
        this.copy(texture, new iRectangle(destination.x, destination.y,
                texture.dimensions.x, texture.dimensions.y), sourceRect);
    }

    /**
     * Copies a texture to the window at the given rectangle
     * If sourceRect is null, it will copy the entire texture, otherwise, it will copy the slice defined by sourceRect
     */
    void copy(Texture texture, iRectangle destinationRect, iRectangle sourceRect = null) {
        ensureSafe(SDL_RenderCopy(this.renderer, texture.handle,
                (sourceRect is null) ? null : sourceRect.handle, destinationRect.handle));
    }

    /**
     * Copies a texture to the window at the given rectangle with the given angle
     * If sourceRect is null, it will copy the entire texture, otherwise, it will copy the slice defined by sourceRect
     * Angles are given in radians
     */
    void copy(Texture texture, iRectangle destinationRect, double angle,
            SDL_RendererFlip flip = SDL_FLIP_NONE, iVector center = null,
            iRectangle sourceRect = null) {
        ensureSafe(SDL_RenderCopyEx(this.renderer, texture.handle, (sourceRect is null)
                ? null : sourceRect.handle, destinationRect.handle,
                angle * 180 / PI, (center is null) ? null : center.handle, flip));
    }

    /**
     * Fills the screen with the existing renderer color
     */
    void clear() {
        ensureSafe(SDL_RenderClear(this.renderer));
    }

    /**
     * Sets the renderer's color and clears the screen
     */
    void clear(Color color) {
        immutable oldColor = this.drawColor;
        this.drawColor = color;
        this.clear();
        this.drawColor = oldColor;
    }

    /**
     * Internally used function that performs an action with a certain color
     */
    private void performWithColor(Color color, void delegate() action) {
        immutable oldColor = this.drawColor;
        this.drawColor = color;
        action();
        this.drawColor = oldColor;
    }

    /**
     * Draws a line between the given points
     */
    void drawLine(iVector first, iVector second) {
        ensureSafe(SDL_RenderDrawLine(this.renderer, first.x, first.y, second.x, second.y));
    }

    /**
     * Draws a line of a given color between the given points
     */
    void drawLine(iVector first, iVector second, Color color) {
        this.performWithColor(color, {this.drawLine(first, second);});
    }

    /**
     * Draws a line given a segment
     */
    void drawLine(Segment!(int, 2) line) {
        this.drawLine(line.initial, line.terminal);
    }

    /**
     * Draws a line with a specific color
     */
    void drawLine(Segment!(int, 2) line, Color color) {
        this.performWithColor(color, {this.drawLine(line);});
    }

    /**
     * Draws a point
     */
    void drawPoint(iVector toDraw) {
        ensureSafe(SDL_RenderDrawPoint(this.renderer, toDraw.x, toDraw.y));
    }

    /**
     * Draws a point in the given color
     */
    void drawPoint(iVector toDraw, Color color) {
        this.performWithColor(color, {this.drawPoint(toDraw);});
    }

    /**
     * Draws a rectangle
     */
    void drawRect(iRectangle toDraw) {
        ensureSafe(SDL_RenderDrawRect(this.renderer, toDraw.handle));
    }

    /**
     * Draws a rectangle with the given color
     */
    void drawRect(iRectangle toDraw, Color color) {
        this.performWithColor(color, {this.drawRect(toDraw);});
    }

    /**
     * Fills a rectangle in
     */
    void fillRect(iRectangle toFill) {
        ensureSafe(SDL_RenderFillRect(this.renderer, toFill.handle));
    }

    /**
     * Fills a rectangle in with the given color
     */
    void fillRect(iRectangle toFill, Color color) {
        this.performWithColor(color, {this.fillRect(toFill);});
    }

    /**
     * Draws a polygon
     */
    void drawPolygon(ulong sides)(iPolygon!sides toDraw) {
        foreach (i; 0 .. toDraw.vertices.length) {
            this.drawLine(toDraw.vertices[i], toDraw.vertices[(i + 1) % toDraw.vertices.length]);
        }
    }

    /**
     * Draws a polygon with the given color
     */
    void drawPolygon(ulong sides)(iPolygon!sides toDraw, Color color) {
        this.performWithColor(color, {this.drawPolygon(toDraw);});
    }

    /**
     * Fills a polygon
     * Uses scanlining
     * TODO: could be much more efficient
     */
    void fillPolygon(ulong sides)(iPolygon!sides toDraw) {
        iRectangle bounds = bound(toDraw);
        int[][int] intersections; //Stores a list of x coordinates of intersections accessed by the y value
        foreach (polygonSide; toDraw.sides) {
            foreach (y; bounds.y .. bounds.bottomLeft.y) {
                //Checks that the y value exists within the segment
                if ((y - polygonSide.initial.y) * (y - polygonSide.terminal.y) > 0) {
                    continue;
                }
                //If the segment is a horizontal line at this y, draws the horizontal line and then breaks
                if (y == polygonSide.initial.y && polygonSide.initial.y == polygonSide.terminal.y) {
                    this.drawLine(polygonSide.initial, polygonSide.terminal);
                    continue;
                }
                //Vertical lines
                if(polygonSide.initial.x == polygonSide.terminal.x) {
                    intersections[y] ~= polygonSide.initial.x;
                    continue;
                }
                
                //TODO: explain; the genius Saurabh Totey worked this out but has difficulty explaining how he got this math
                iVector sideDirection = polygonSide.direction;
                immutable dy = y - polygonSide.initial.y;
                intersections[y] ~= (dy * sideDirection.x + polygonSide.initial.x * sideDirection.y) / sideDirection.y;
            
            }
        }
        foreach(y, xValues; intersections) {
            foreach (i; 0 .. xValues.sort.length - 1) {
                this.drawLine(new iVector(xValues[i], y), new iVector(xValues[i + 1], y));
            }
        }
    }

    /**
     * Fills a polygon with a given color
     */
    void fillPolygon(ulong sides)(iPolygon!sides toDraw, Color color) {
        this.performWithColor(color, {this.fillPolygon!sides(toDraw);});
    }

    /**
     * Updates what the renderer has drawn by actually outputting or presenting it
     */
    void present() {
        SDL_RenderPresent(this.renderer);
        this.clear();
    }

}
