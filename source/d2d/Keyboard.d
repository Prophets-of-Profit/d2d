module d2d.Keyboard;

import std.algorithm;
import std.array;
import std.datetime;
import d2d.EventHandler;
import d2d.InputSource;
import d2d.sdl2;

///A list of all of the key codes
immutable SDL_Keycode[] allKeyCodes = [ /*TODO*/ ];

/**
 * The keyboard input source which accumulates keyboard information
 */
class Keyboard : InputSource!SDL_Keycode, EventHandler {

    private Pressable!SDL_Keycode[] allKeys; ///All of the pressable structs visible

    /**
     * Initializes all keys of a keyboard
     */
    this() {
        this.allKeys = allKeyCodes.map!(code => new Pressable!SDL_Keycode(code)).array;
    }

    /**
     * Returns all of the keys on the keyboard
     */
    override @property Pressable!SDL_Keycode[] allPressables() {
        return this.allKeys.dup;
    }

    /**
     * Accumulates all of the keyboard events and updates stored pressables accordingly
     */
    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_KEYDOWN) {
            this.allKeys.filter!(key => key.id == event.key.keysym.sym)
                .array[0].lastPressed = Clock.currTime();
        }
        else if (event.type == SDL_KEYUP) {
            this.allKeys.filter!(key => key.id == event.key.keysym.sym)
                .array[0].lastReleased = Clock.currTime();
        }
    }

}
