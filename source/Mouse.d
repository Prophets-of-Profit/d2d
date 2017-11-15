module d2d.Mouse;

import d2d.InputSource;

import derelict.sdl2.sdl;

class Mouse : InputSource {

    override @property Pressable[] allPressables(){
        return null;
    }

    override void handleEvent(){

    }

}
