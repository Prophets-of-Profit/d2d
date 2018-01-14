module d2d.sdl2;

public import derelict.sdl2.sdl;
public import derelict.sdl2.image;
public import derelict.sdl2.mixer;
public import derelict.sdl2.ttf;
public import derelict.sdl2.net;
public import d2d.sdl2.Color;
public import d2d.math;
public import d2d.sdl2.EventHandler;
public import d2d.sdl2.Font;
public import d2d.sdl2.InputSource;
public import d2d.sdl2.Keyboard;
public import d2d.sdl2.Mouse;
public import d2d.sdl2.Rectangle;
public import d2d.sdl2.Renderer;
public import d2d.sdl2.Sound;
public import d2d.sdl2.Surface;
public import d2d.sdl2.Texture;
public import d2d.sdl2.Window;

import std.conv;

/**
 * Loads base DerelictSDL2
 * Function can be called many times, but load only happens once
 */
void loadLibSDL(SharedLibVersion ver = SharedLibVersion(2, 0, 2)) {
    static bool hasBeenLoaded;
    if (hasBeenLoaded)
        return;
    hasBeenLoaded = true;
    DerelictSDL2.load(ver);
    ensureSafe(SDL_Init(SDL_INIT_EVERYTHING));
}

/**
 * Loads SDL_Image libraries
 * Function can be called many times, but load only happens once
 */
void loadLibImage() {
    static bool hasBeenLoaded;
    if (hasBeenLoaded)
        return;
    hasBeenLoaded = true;
    DerelictSDL2Image.load();
    IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF);
}

/**
 * Loads SDL_Mixer libraries
 * Function can be called many times, but load only happens once
 */
void loadLibMixer() {
    static bool hasBeenLoaded;
    if (hasBeenLoaded)
        return;
    hasBeenLoaded = true;
    DerelictSDL2Mixer.load();
    ensureSafe(Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT,
            MIX_DEFAULT_CHANNELS, 4096));
}

/**
 * Loads SDL_ttf libraries
 * Function can be called many times, but load only happens once
 */
void loadLibTTF() {
    static bool hasBeenLoaded;
    if (hasBeenLoaded)
        return;
    hasBeenLoaded = true;
    DerelictSDL2ttf.load();
    ensureSafe(TTF_Init());
}

/**
 * Takes in an integer output from an SDL function and then throws an error if the integer isn't 0
 * Because SDL doesn't throw errors, but rather returns codes, 0 means a successful finish to a function
 * Any non-zero output from a function means that SDL encountered an error, and this function will throw upon an SDL error
 */
void ensureSafe(int output) {
    if (output != 0) {
        immutable string errorMessage = SDL_GetError().to!string;
        SDL_ClearError();
        throw new Exception(errorMessage);
    }
}

/**
 * Takes in an object from an SDL function and then throws an error if the object is null
 * Because SDL doesn't throw errors upon failed object creation, but constructs the object as a null, a non-null object means a successful creation
 * Any null creation means that SDL encountered an error, and this function will throw an SDL error accordingly
 */
T ensureSafe(T)(T output) {
    ensureSafe((output is null).to!int);
    return output;
}

//A completely pointless variable to allow turning a 2d vector into an SDL_Point*; variable needed because excaping references is not allowed
SDL_Point temp;

/**
 * Gets a 2d vector as an SDL_Point*
 */
SDL_Point* handle(iVector vec) {
    temp = SDL_Point(vec.x, vec.y);
    return &temp;
}
