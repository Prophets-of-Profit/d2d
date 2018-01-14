module d2d.sdl2.Mouse;

import std.algorithm;
import std.datetime;
import d2d.sdl2;

///A list of all of the button codes
immutable allButtonCodes = [
    SDL_BUTTON_LEFT, SDL_BUTTON_MIDDLE, SDL_BUTTON_RIGHT, SDL_BUTTON_X1, SDL_BUTTON_X2
];

/**
 * The mouse input source which acculmulates mouse information
 */
class Mouse : InputSource!uint, EventHandler {

    private Pressable!uint[uint] _allButtons; ///All of the buttons on the mouse
    private iVector _totalWheelDisplacement; ///Total displacement of the mousewheel since mouse construction
    private iVector _location; ///The location of the mouse accounting for logical size or viewport

    alias allButtons = allPressables; ///Allows allPressables to be called as allButtons

    /**
     * Returns all of the mouse buttons
     */
    override @property Pressable!uint[uint] allPressables() {
        return this._allButtons.dup;
    }

    /**
     * Gets the mouse location accounting for logical size or viewport
     * This should be what is most regularly used
     */
    @property iVector location() {
        return this._location;
    }

    /**
     * Sets the location of the mouse relative to the window
     */
    @property void windowLocation(iVector location) {
        SDL_WarpMouseInWindow(null, location.x, location.y);
    }

    /**
     * Gets the location of the mouse
     */
    @property iVector windowLocation() {
        iVector location = new iVector(-1, -1);
        SDL_GetMouseState(&location.components[0], &location.components[1]);
        return location;
    }

    /**
     * Sets the location of the mouse globally
     */
    @property void screenLocation(iVector location) {
        SDL_WarpMouseGlobal(location.x, location.y);
    }

    /**
     * Gets the location of the mouse globally
     */
    @property iVector screenLocation() {
        iVector location = new iVector(-1, -1);
        SDL_GetGlobalMouseState(&location.components[0], &location.components[1]);
        return location;
    }

    /**
     * Gets by how much the mouse wheel has been displaced
     * Records changes in wheel from the start of mouse construction
     */
    @property iVector totalWheelDisplacement() {
        return this._totalWheelDisplacement;
    }

    /**
     * Sets the cursor of the mouse
     */
    @property void cursor(Cursor newCursor) {
        SDL_SetCursor(newCursor.handle);
    }

    /**
     * Gets the cursor of the mouse
     * Special precautions must be taken when using this method:
     * Make sure to store the output of the cursor or make sure the cursor doesn't get GCed
     * Because the actual cursor is being used in C, D will think this returned cursor won't be being used and destroy it
     * It is probably better to avoid this method entirely
     */
    @property Cursor cursor() {
        return new Cursor(ensureSafe(SDL_GetCursor()));
    }

    /**
     * Makes a mouse and initializes all of the buttons
     */
    this() {
        allButtonCodes.each!(
                buttonCode => this._allButtons[buttonCode] = new Pressable!uint(buttonCode));
        this._totalWheelDisplacement = new iVector(0, 0);
        this._location = new iVector(0, 0);
    }

    /**
     * Acculmulates all of the mouse events and updates stored pressables accordingly
     */
    override void handleEvent(SDL_Event event) {
        switch (event.type) {
        case SDL_MOUSEMOTION:
            this._location.x = event.button.x;
            this._location.y = event.button.y;
            break;
        case SDL_MOUSEBUTTONDOWN:
            this._allButtons[event.button.button].lastPressed = Clock.currTime();
            break;
        case SDL_MOUSEBUTTONUP:
            this._allButtons[event.button.button].lastReleased = Clock.currTime();
            break;
        case SDL_MOUSEWHEEL:
            this._totalWheelDisplacement.x += event.wheel.x;
            this._totalWheelDisplacement.y += event.wheel.y;
            break;
        default:
            break;
        }
    }

}

/**
 * A cursor is how the mouse at its location looks
 * While this class should *technically* be defined in d2d.sdl2, its only use is in Mouse
 * And since this class is small, instead of giving it its own file, I'll keep it here
 */
class Cursor {

    private SDL_Cursor* cursor;

    /**
     * Returns the raw SDL data of this object
     */
    @property handle() {
        return this.cursor;
    }

    /**
     * Creates a cursor from a surface and the hotspot
     * The hotspot is where on the surface is the actual mouse location
     */
    this(Surface appearance, iVector hotspot) {
        this.cursor = ensureSafe(SDL_CreateColorCursor(appearance.handle, hotspot.x, hotspot.y));
    }

    /**
     * Creates a cursor from a predefined system cursor
     */
    this(SDL_SystemCursor id) {
        this.cursor = ensureSafe(SDL_CreateSystemCursor(id));
    }

    /**
     * Creates a cursor from an already SDL_Cursor
     */
    this(SDL_Cursor* alreadyExisting) {
        this.cursor = alreadyExisting;
    }

    /**
     * Ensures that SDL can properly dispose of the cursor
     */
    ~this() {
        SDL_FreeCursor(this.cursor);
    }

}

/** 
 * Gets the system's default cursor
 */
Cursor defaultCursor() {
    return new Cursor(ensureSafe(SDL_GetDefaultCursor()));
}
