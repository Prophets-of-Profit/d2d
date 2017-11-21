module d2d.sdl2.Texture;

import d2d.sdl2;

/**
 * Textures are a rectangular collection of pixels
 * Textures are fast and can be drawn using a renderer
 * Textures can be created from a more easily edited surface
 * Textures are handled in hardware as opposed to surfaces which are handled in software
 * When used repeatedly and stored, textures should be preferred, but surfaces should be used when flexibility is desired
 */
class Texture {

    private SDL_Texture* texture;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Texture* handle(){
        return this.texture;
    }

    /**
     * Gets the texture's dimensions as a point with the width being the x coordinate and the height being the y coordinate
     */
    @property iPoint dimensions(){
        iPoint dim = new iPoint(0, 0);
        SDL_QueryTexture(this.texture, null, null, &dim.x, &dim.y);
        return dim;
    }

    /**
     * Constructs a new texture from a surface
     */
    this(Surface surface, Renderer renderer){
        SDL_CreateTextureFromSurface(renderer.handle, surface.handle);
    }

    /**
     * Ensures that SDL can properly dispose of the texture
     */
    ~this(){
        SDL_DestroyTexture(this.texture);
    }

}
