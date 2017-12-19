module d2d.InputSource;

import std.algorithm;
import std.array;
import std.datetime;
public import d2d.EventHandler;

/**
 * A pressable input source that stores it's own state
 * State gets updated by an InputSource class that contains the pressable
 */
class Pressable(T) {

    immutable T id; ///The identifier for the pressable
    SysTime lastPressed; ///The time at which this pressable was pressed
    SysTime lastReleased; ///The time at which this pressable was released

    /**
     * Constructor for a pressable takes its id
     */
    this(T id){
        this.id = id;
    }

    /**
     * Returns whether or not this pressable is currently being held
     */
    @property bool isPressed() {
        return this.lastReleased < this.lastPressed;
    }

    /**
     * Checks if this pressable is pressed
     * If it is, it will mark it as released
     * Returns whether this was actually pressed or not
     */
    bool testAndRelease() {
        if (!this.isPressed) {
            return false;
        }
        this.lastReleased = Clock.currTime();
        return true;
    }

}

/**
 * A source of input from the user
 * Handles acculmulating events and storing all the states of all the pressables
 * The template parameter is the type for the identifier of all pressables
 */
abstract class InputSource(T) : EventHandler {

    @property Pressable!T[] allPressables(); ///Return a list of all of the pressables that can be accessed by the template type

    /**
     * Returns a list of all of the pressables that are held down.
     */
    Pressable!T[] getPressedPressables() {
        return this.allPressables.filter!(pressable => pressable.isPressed).array;
    }

}
