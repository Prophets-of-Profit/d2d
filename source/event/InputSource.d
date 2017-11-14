module d2d.event.InputSource;

import std.datetime;

struct Pressable {

    bool isPressed;
    SysTime lengthPressed;
    uint Id;             //Whatever key/button codes in SDL are.

}

abstract class InputSource {

    Pressable[] allKeys;

    Pressable[] getPressedPressables(){return null;}

    abstract void handleEvent();

}
