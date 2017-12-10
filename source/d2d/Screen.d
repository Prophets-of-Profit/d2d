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

    protected Display container; ///The displlay that contains this screen
    protected Component[] components; ///All the components that the screen contains;

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
     * How the screen should be drawn; has default behaviour
     * Default behaviour is just to draw all components with first components drawn first
     */
    void draw() {
        this.components.each!(component => component.draw());
    }

    /**
     * An event receiver to allow the screen to receieve and respond to events
     * Default behaviour is to send events to components
     */
    override void handleEvent(SDL_Event event){
        this.components.each!(component => component.handleEvent(event));
    }

    /**
     * What the screen should do every frame
     */
    void onFrame();

}