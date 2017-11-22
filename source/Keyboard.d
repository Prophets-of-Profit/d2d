module d2d.Keyboard;

import d2d.InputSource;

import d2d.sdl2;

/**
 * The keyboard input source which acculmulates keyboard information
 */
class Keyboard : InputSource {

    /**
     * Returns all of the keys on the keyboard
     */
    override @property Pressable[] allPressables() {
        return null;
    }

    /**
     * Acculmulates all of the keyboard events and updates stored pressables accordingly
     */
    override void handleEvent(SDL_Event event) {

    }

}
