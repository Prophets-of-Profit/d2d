/**
 * Component
 */
module d2d.Component;

import d2d;

/**
 * A component defines something that can be drawn, handle events, and takes up a space on the screen
 */
abstract class Component : EventHandler {

    protected Display container; ///The display that contains this component

    /**
     * It may be useful for a component to have access to it's containing display
     */
    this(Display container) {
        this.container = container;
    }

    @property iRectangle location(); ///Gets where the component is on the screen
    void draw(); ///How the component should draw itself on the screen

}
