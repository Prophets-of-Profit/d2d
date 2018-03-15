module d2d.Activity;

import std.algorithm;
import d2d;

/**
 * An object that represents an Activity or a Screen or a point in time of the display
 * Draws itself to the screen, can handle events, and can contain components which do the same
 * Adding components to an activity ensures that they will automatically get handled as long as the activity is active
 */
abstract class Activity : EventHandler {

    Component[] components; ///All the components that the screen contains; components are handled separately from the screen
    protected Display container; ///The display that contains this screen

    /**
     * It may be useful for a screen to have access to it's containing display
     */
    this(Display container) {
        this.container = container;
    }

    /**
     * How the screen should respond to events
     * Is necessary because it is an event handler
     */
    void handleEvent(SDL_Event event) {}

    /**
     * How the screen should be drawn
     * Drawing of screen components is handled after this method
     */
    void draw() {}

    /**
     * What the screen should do every screen update
     * If the renderer is on VSync, update may be called more than once per actual frame
     * Can be treated as the insides of a while(true) loop
     */
    void update() {}

}
