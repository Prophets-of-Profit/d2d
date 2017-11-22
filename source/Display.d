module d2d.sdl2.Display;

import d2d.Keyboard;
import d2d.Mouse;
import d2d.sdl2;

/**
 * A display that handles collecting events and drawing to the screen and handling window stuff
 * Will handle the main loop and send events to where they need to be handled
 */
class Display {

    private int framerate; ///The framerate of the window. If negative, it will be vsync
    private Keyboard keyboard; ///The keyboard input source
    private Mouse mouse; ///The mouse input source
    private Window window; ///The actual SDL window

}
