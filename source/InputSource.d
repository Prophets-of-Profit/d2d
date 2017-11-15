module d2d.InputSource;

import std.algorithm;
import std.array;
import std.datetime;

/**
 * A pressable input source
 */
struct Pressable {

    uint id;                          ///The key/button that is pressed
    SysTime lastPressed;              ///The time at which this pressable was pressed
    SysTime lastReleased;             ///The time at which this pressable was released

    /**
     * Returns whether or not this pressable is currently being held
     */
    @property bool isPressed(){
        return this.lastReleased < this.lastPressed;
    }

}


/**
 * A source of input from the user
 */
abstract class InputSource {

    @property Pressable[] allPressables();      ///Return a list of all of the pressables
    void handleEvent();                         ///Handle the events

    /**
     * Returns a list of all of the pressables that are held down.
     */
    Pressable[] getPressedPressables(){
        return this.allPressables.filter!(pressable => pressable.isPressed).array;
    }

}
