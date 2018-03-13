module d2d.sdl2;

public import derelict.sdl2.sdl;
public import derelict.sdl2.image;
public import derelict.sdl2.mixer;
public import derelict.sdl2.ttf;
public import derelict.sdl2.net;
public import d2d.math;
public import d2d.sdl2.Color;
public import d2d.sdl2.EventHandler;
public import d2d.sdl2.Font;
public import d2d.sdl2.InputSource;
public import d2d.sdl2.Keyboard;
public import d2d.sdl2.Mouse;
public import d2d.sdl2.Polygon;
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

//Completely pointless temporary variables to get math objects into SDL structs
private SDL_Point tempPoint;
private SDL_Rect tempRect;

/**
 * Gets a 2d vector as an SDL_Point*
 */
SDL_Point* handle(iVector vec) {
    tempPoint = SDL_Point(vec.x, vec.y);
    return &tempPoint;
}

/**
 * Gets a 2d axis aligned bounding box as an SDL_Rect*
 */
SDL_Rect* handle(iRectangle rec) {
    tempRect = SDL_Rect(rec.initialPoint.x, rec.initialPoint.y, rec.extent.x, rec.extent.y);
    return &tempRect;
}

/**
 * Gets a 2d axis aligned bounding box as a polygon
 */
Polygon!(T, 4) toPolygon(T)(AxisAlignedBoundingBox!(T, 2) rec) {
    return new Polygon!(T, 4)(rec.topLeft, rec.topRight, rec.bottomRight, rec.bottomLeft);
}

//Aliases 2d vectors to their commonly used presets
alias iVector = Vector!(int, 2);
alias dVector = Vector!(double, 2);
alias fVector = Vector!(float, 2);

//Aliases 2d axis aligned bounding boxes to their commonly used presets
alias iRectangle = AxisAlignedBoundingBox!(int, 2);
alias dRectangle = AxisAlignedBoundingBox!(double, 2);
alias fRectangle = AxisAlignedBoundingBox!(float, 2);

//Aliases 2d segments to their commonly used presets
alias iSegment = Segment!(int, 2);
alias dSegment = Segment!(double, 2);
alias fSegment = Segment!(float, 2);
