module d2d.sdl2;

public import derelict.sdl2.sdl;
public import derelict.sdl2.image;
public import derelict.sdl2.mixer;
public import derelict.sdl2.ttf;
public import derelict.sdl2.net;
public import d2d.sdl2.Renderer;
public import d2d.sdl2.Surface;
public import d2d.sdl2.Texture;
public import d2d.sdl2.Window;
public import d2d.Utility;

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
    SDL_Init(SDL_INIT_EVERYTHING);
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
    Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, MIX_DEFAULT_CHANNELS, 1024);
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
