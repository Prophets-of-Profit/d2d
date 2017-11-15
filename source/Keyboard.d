module d2d.Keyboard;

import d2d.InputSource;

import derelict.sdl2.sdl;

class Keyboard : InputSource {

    override @property Pressable[] allPressables(){
        return null;
    }

    override void handleEvent(){

    }

}
