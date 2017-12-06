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
    @property SDL_Texture* handle() {
        return this.texture;
    }

    /**
     * Gets the texture's dimensions as a point with the width being the x coordinate and the height being the y coordinate
     */
    @property iPoint dimensions() {
        iPoint dim = new iPoint(0, 0);
        SDL_QueryTexture(this.texture, null, null, &dim.x, &dim.y);
        return dim;
    }

    /** 
     * Sets the texture's alpha value
     */
    @property void alphaMod(ubyte alphaMultiplier){
        ensureSafe(SDL_SetTextureAlphaMod(this.texture, alphaMultiplier));
    }

    /**
     * Gets the texture's alpha value
     */
    @property ubyte alphaMod(){
        ubyte alphaMultiplier;
        ensureSafe(SDL_GetTextureAlphaMod(this.texture, &alphaMultiplier));
        return alphaMultiplier;
    }

    /**
     * Sets the texture's blend mode
     */
    @property void blendMode(SDL_BlendMode blend){
        ensureSafe(SDL_SetTextureBlendMode(this.texture, blend));
    }

    /**
     * Gets the texture's blend mode
     */
    @property SDL_BlendMode* blendMode(){
        SDL_BlendMode* blend;
        ensureSafe(SDL_GetTextureBlendMode(this.texture, blend));
        return blend;
    }

    /**
     * Sets the color modifier for the surface
     * Color modification works by multiplying the colorMultiplier / 255 into the surface pixels
     */
    @property void colorMod(Color colorMultiplier) {
        ensureSafe(SDL_SetTextureColorMod(this.texture, colorMultiplier.r, colorMultiplier.g, colorMultiplier.b));
    }

    /**
     * Gets the color modifier for the surface
     * Color modification works by multiplying the colorMultiplier / 255 into the surface pixels
     */
    @property Color colorMod() {
        Color colorMultiplier;
        ensureSafe(SDL_GetTextureColorMod(this.texture, &colorMultiplier.r, &colorMultiplier.g, &colorMultiplier.b));
        return colorMultiplier;
    }

    /**
     * Constructs a new texture from a surface
     */
    this(Surface surface, Renderer renderer) {
        this.texture = ensureSafe(SDL_CreateTextureFromSurface(renderer.handle, surface.handle));
    }

    /**
     * Creates a texture from an already existing SDL_Texture
     */
    this(SDL_Texture* alreadyExisting){
        this.texture = alreadyExisting;
    }

    /**
     * Creates a texture given explicit parameters
     */
    this(SDL_Renderer* renderer, uint format, SDL_TextureAccess access, int width, int height){
        this.texture = ensureSafe(SDL_CreateTexture(renderer, format, access, width, height));
    }

    /**
     * Ensures that SDL can properly dispose of the texture
     */
    ~this() {
        SDL_DestroyTexture(this.texture);
    }

}
