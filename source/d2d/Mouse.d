module d2d.Mouse;

import std.algorithm;
import std.array;
import std.datetime;
import d2d.EventHandler;
import d2d.InputSource;
import d2d.sdl2;

/**
 * The mouse input source which acculmulates mouse information
 */
class Mouse : InputSource!uint, EventHandler {

    private Pressable!uint[] _allButtons; ///All of the buttons on the mouse
    private iPoint _screenLocation; ///Location of the mouse within the entire screen
    private iPoint _windowLocation; ///Location of the mouse within the window

    alias allButtons = allPressables; ///Allows allPressables to be called as allButtons

    /**
     * Makes a mouse and initializes all of the buttons
     */
    this() {
        this._allButtons = [new Pressable!uint(SDL_BUTTON_LEFT), new Pressable!uint(SDL_BUTTON_MIDDLE),
            new Pressable!uint(SDL_BUTTON_RIGHT),
            new Pressable!uint(SDL_BUTTON_X1), new Pressable!uint(SDL_BUTTON_X2)];
    }

    /**
     * Returns all of the mouse buttons
     */
    override @property Pressable!uint[] allPressables() {
        return this._allButtons.dup;
    }

    /**
     * Sets the location of the mouse relative to the window
     */
    @property void windowLocation(iPoint location) {
        SDL_WarpMouseInWindow(null, location.x, location.y);
    }

    /**
     * Gets the location of the mouse
     */
    @property iPoint windowLocation() {
        iPoint location = new iPoint(-1, -1);
        SDL_GetMouseState(&location.x, &location.y);
        return location;
    }

    /**
     * Sets the location of the mouse globally
     */
    @property void screenLocation(iPoint location) {
        SDL_WarpMouseGlobal(location.x, location.y);
    }

    /**
     * Gets the location of the mouse globally
     */
    @property iPoint screenLocation() {
        iPoint location = new iPoint(-1, -1);
        SDL_GetGlobalMouseState(&location.x, &location.y);
        return location;
    }

    //TODO mousewheel stuff

    /**
     * Acculmulates all of the mouse events and updates stored pressables accordingly
     */
    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_MOUSEBUTTONDOWN) {
            this._allButtons.filter!(button => button.id == event.button.button)
                .array[0].lastPressed = Clock.currTime();
        }
        else if (event.type == SDL_KEYUP) {
            this._allButtons.filter!(button => button.id == event.button.button)
                .array[0].lastReleased = Clock.currTime();
        }
    }

}
