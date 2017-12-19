module d2d.Screen;

import std.algorithm;
import d2d.Component;
import d2d.Display;
import d2d.EventHandler;
import d2d.sdl2;

/**
 * An object that represents an Activity or a Screen or a point in time of the display
 * Draws itself to the screen, can handle events, and can contain components which do the same
 */
abstract class Screen : EventHandler {

    Component[] components; ///All the components that the screen contains; components are handled before screen
    protected Display container; ///The display that contains this screen

    /**
     * It may be useful for a screen to have access to it's containing display
     */
    this(Display container) {
        this.container = container;
    }

    /**
     * Ensures that all components get destroyed
     */
    ~this() {
        this.components.each!(component => component.destroy());
    }

    /**
     * How the screen should be drawn
     * Drawing of screen components is handled after this method
     */
    void draw();

    /**
     * An event receiver to allow the screen to receieve and respond to events
     * Sending of events to components is handled before this method
     */
    override void handleEvent(SDL_Event event);

    /**
     * What the screen should do every frame
     */
    void onFrame();

}
