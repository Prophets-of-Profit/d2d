module d2d.Keyboard;

import d2d.EventHandler;
import d2d.InputSource;
import d2d.sdl2;

import std.algorithm;
import std.datetime;

/**
 * The keyboard input source which accumulates keyboard information
 */
class Keyboard : InputSource, EventHandler {

    Pressable[SDL_Keycode] allKeys;        ///All of the pressable structs visible

    /**
     * Returns all of the keys on the keyboard
     */
    override @property Pressable[] allPressables() {
        return allKeys.values;
    }

    /**
     * Accumulates all of the keyboard events and updates stored pressables accordingly
     */
    override void handleEvent(SDL_Event event) {
        if(event.type == SDL_KEYDOWN){
            if(!this.allKeys.keys.canFind(event.key.keysym.sym)){
                this.allKeys[event.key.keysym.sym] = Pressable();
            }
            this.allKeys[event.key.keysym.sym].lastPressed = Clock.currTime();
        }else if(event.type == SDL_KEYUP){
            if(!this.allKeys.keys.canFind(event.key.keysym.sym)){
                this.allKeys[event.key.keysym.sym] = Pressable();
            }
            this.allKeys[event.key.keysym.sym].lastReleased = Clock.currTime();
        }
    }

}
