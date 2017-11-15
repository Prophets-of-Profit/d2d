module d2d.Keyboard;

import d2d.InputSource;

import derelict.sdl2.sdl;

/**
 * An InputSource to handle all keyboard events.
 */
class Keyboard : InputSource {

    /**
     * Returns all of the keys on the keyboard
     */
    override @property Pressable[] allPressables(){
        return null;
    }

    /**
     * Handles all keyboard events
     */
    override void handleEvent(){

    }

}
