module d2d.InputSource;

import std.algorithm;
import std.array;
import std.datetime;
import d2d.EventHandler;
import d2d.sdl2;

/**
 * A pressable input source that stores it's own state
 * State gets updated by an InputSource class that contains the pressable
 */
struct Pressable {

    uint id; ///The key/button that is pressed
    SysTime lastPressed; ///The time at which this pressable was pressed
    SysTime lastReleased; ///The time at which this pressable was released

    /**
     * Returns whether or not this pressable is currently being held
     */
    @property bool isPressed() {
        return this.lastReleased < this.lastPressed;
    }

}

/**
 * A source of input from the user
 * Handles acculmulating events and storing all the states of all the pressables
 */
abstract class InputSource : EventHandler {

    @property Pressable[] allPressables(); ///Return a list of all of the pressables

    /**
     * Returns a list of all of the pressables that are held down.
     */
    Pressable[] getPressedPressables() {
        return this.allPressables.filter!(pressable => pressable.isPressed).array;
    }

}
