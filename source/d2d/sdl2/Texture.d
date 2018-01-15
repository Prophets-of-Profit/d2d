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
    @property iVector dimensions() {
        iVector dim = new iVector(0, 0);
        SDL_QueryTexture(this.texture, null, null, &dim.x, &dim.y);
        return dim;
    }

    /**
     * Gets the texture's pixel format
     * The pixel format is the format in which information about the pixels is stored (e.g. RGBA)
     */
    @property uint format() {
        uint format;
        SDL_QueryTexture(this.texture, &format, null, null, null);
        return format;
    }

    /**
     * Gets the texture's access value
     * Acces value determines how the texture can be accessed or modified 
     * Potential values are: 
     * SDL_TEXTUREACCESS_STATIC: texture changes rarely, and is not lockable
     * SDL_TEXTUREACCESS_STREAMING: texture changes frequently, and is lockable
     * SDL_TEXTUREACCESS_TARGET: texturecan be used as a render target
     */
    @property int access() {
        int access;
        SDL_QueryTexture(this.texture, null, &access, null, null);
        return access;
    }

    /** 
     * Sets the texture's alpha value, or transparency, if possible
     * Alpha varies from 0 to 255
     */
    @property void alphaMod(ubyte alphaMultiplier) {
        ensureSafe(SDL_SetTextureAlphaMod(this.texture, alphaMultiplier));
    }

    /**
     * Gets the texture's alpha value, or transparency, if possible
     * Alpha varies from 0 to 255
     */
    @property ubyte alphaMod() {
        ubyte alphaMultiplier;
        ensureSafe(SDL_GetTextureAlphaMod(this.texture, &alphaMultiplier));
        return alphaMultiplier;
    }

    /**
     * Sets the texture's blend mode
     * Modes include:
     * SDL_BLENDMODE_NONE: no blending
     * SDL_BLENDMODE_BLEND: alpha blending
     * SDL_BLENDMODE_ADD: additive blending
     * SDL_BLENDMODE_MOD: color modulate
     */
    @property void blendMode(SDL_BlendMode blend) {
        ensureSafe(SDL_SetTextureBlendMode(this.texture, blend));
    }

    /**
     * Gets the texture's blend mode
     * Modes include:
     * SDL_BLENDMODE_NONE: no blending
     * SDL_BLENDMODE_BLEND: alpha blending
     * SDL_BLENDMODE_ADD: additive blending
     * SDL_BLENDMODE_MOD: color modulate
     */
    @property SDL_BlendMode* blendMode() {
        SDL_BlendMode* blend;
        ensureSafe(SDL_GetTextureBlendMode(this.texture, blend));
        return blend;
    }

    /**
     * Sets the color modifier for the surface
     * Color modification works by multiplying the colorMultiplier / 255 into the surface pixels
     */
    @property void colorMod(Color colorMultiplier) {
        ensureSafe(SDL_SetTextureColorMod(this.texture, colorMultiplier.r,
                colorMultiplier.g, colorMultiplier.b));
    }

    /**
     * Gets the color modifier for the surface
     * Color modification works by multiplying the colorMultiplier / 255 into the surface pixels
     */
    @property Color colorMod() {
        Color colorMultiplier;
        ensureSafe(SDL_GetTextureColorMod(this.texture, &colorMultiplier.r,
                &colorMultiplier.g, &colorMultiplier.b));
        return colorMultiplier;
    }

    /**
     * Creates a texture given explicit parameters that are required by SDL CreateTexture
     * Allows for more control over how the texture works
     */
    this(Renderer renderer, uint format, SDL_TextureAccess access, iVector dimensions) {
        this.texture = ensureSafe(SDL_CreateTexture(renderer.handle, format,
                access, dimensions.x, dimensions.y));
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
    this(SDL_Texture* alreadyExisting) {
        this.texture = alreadyExisting;
    }

    /**
     * Ensures that SDL can properly dispose of the texture
     */
    ~this() {
        SDL_DestroyTexture(this.texture);
    }

    /**
     * Locks a texture from editing
     */
    void lock(void** pixels, int* pitch, iRectangle location = null) {
        ensureSafe(SDL_LockTexture(this.texture, (location is null) ? null
                : location.handle, pixels, pitch));
    }

    /**
     * Unlocks a texture to edit
     */
    void unlock() {
        SDL_UnlockTexture(this.texture);
    }

    /**
     * Updates a texture with new pixel data
     */
    void update(void* pixels, int pitch, iRectangle location = null) {
        ensureSafe(SDL_UpdateTexture(this.texture, (location is null) ? null
                : location.handle, pixels, pitch));
    }

}
