module d2d.Window;

import d2d.Keyboard;
import d2d.Mouse;

import derelict.sdl2.sdl;

/**
 * A window that handles collecting events and drawing to the screen
 * Will handle the main loop and send events to where they need to be handled
 */
class Window {

    private int framerate;          ///The framerate of the window. If negative, it will be vsync
    private Keyboard keyboard;      ///The keyboard input source
    private Mouse mouse;            ///The mouse input source
    private SDL_Window* window;      ///The SDL window

    

}
