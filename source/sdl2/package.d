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

shared static this() {
    DerelictSDL2.load();
    DerelictSDL2Image.load();
    DerelictSDL2Mixer.load();
    DerelictSDL2ttf.load();
    DerelictSDL2Net.load();
}
