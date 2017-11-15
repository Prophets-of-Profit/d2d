module d2d.Window;

import d2d.Keyboard;
import d2d.Mouse;

import derelict.sdl2.sdl;

class Window {

    private int framerate;          ///The framerate of the window. If negative, it will be vsync
    private Keyboard keyboard;      ///The keyboard input source
    private Mouse mouse;            ///The mouse input source
    private SDL_Window* window;      ///The SDL window

    

}
