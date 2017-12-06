module d2d.Component;

import d2d.EventHandler;
import d2d.Utility;

/**
 * A component defines something that can be drawn, handle events, and takes up a space on the screen
 */
interface Component : EventHandler {

    iRectangle location(); ///Where the component is on the screen
    void draw(); ///How the component should draw itself on the screen

}