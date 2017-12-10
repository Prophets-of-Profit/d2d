module d2d.Mouse;

import d2d.EventHandler;
import d2d.InputSource;
import d2d.sdl2;

import std.algorithm;
import std.datetime;

/**
 * The mouse input source which acculmulates mouse information
 */
class Mouse : InputSource, EventHandler {

    Pressable[uint] allButtons;    ///All of the buttons on the mouse
    private iPoint screenLocation; ///Location of the mouse within the entire screen
    private iPoint windowLocation; ///Location of the mouse within the window

    /**
     * Returns all of the mouse buttons
     */
    override @property Pressable[] allPressables() {
        return null;
    }
    
    /**
     * Returns the location of the mouse
     */
    @property iPoint location() {
        int x, y;
		SDL_GetMouseState(&x, &y);
        return new iPoint(x, y);
    }

    /**
     * Acculmulates all of the mouse events and updates stored pressables accordingly
     */
    override void handleEvent(SDL_Event event) {
        if(event.type == SDL_MOUSEBUTTONDOWN){
            if(!this.allButtons.keys.canFind(event.button.button)){
                this.allButtons[event.button.button] = Pressable();
            }
            this.allButtons[event.button.button].lastPressed = Clock.currTime();
        }else if(event.type == SDL_KEYUP){
            if(!this.allButtons.keys.canFind(event.button.button)){
                this.allButtons[event.button.button] = Pressable();
            }
            this.allButtons[event.button.button].lastReleased = Clock.currTime();
        }
    }

}
