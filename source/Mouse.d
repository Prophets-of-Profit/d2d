module d2d.Mouse;

import d2d.InputSource;

import derelict.sdl2.sdl;

/**
 * The mouse input source which checks for mouse button events and mouse location
 */
class Mouse : InputSource {

    /**
     * Returns all of the mouse buttons
     */
    override @property Pressable[] allPressables(){
        return null;
    }

    /**
     * Handle all of the mouse events
     */
    override void handleEvent(){

    }

}
