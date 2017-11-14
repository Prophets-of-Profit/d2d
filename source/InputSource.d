module d2d.InputSource;

import std.algorithm;
import std.array;
import std.datetime;

struct Pressable {

    uint id;
    SysTime lastPressed;
    SysTime lastReleased;

    @property bool isPressed(){
        return this.lastReleased < this.lastPressed;
    }

}

abstract class InputSource {

    @property Pressable[] allPressables();
    void handleEvent();

    Pressable[] getPressedPressables(){
        return this.allPressables.filter!(pressable => pressable.isPressed).array;
    }

}
