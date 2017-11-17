module d2d.Mouse;

import d2d.InputSource;

import derelict.sdl2.sdl;

/**
 * The mouse input source which acculmulates mouse information
 */
class Mouse : InputSource {

    /**
     * Returns all of the mouse buttons
     */
    override @property Pressable[] allPressables(){
        return null;
    }

    /**
     * Acculmulates all of the mouse events and updates stored pressables accordingly
     */
    override void handleEvent(){

    }

}
