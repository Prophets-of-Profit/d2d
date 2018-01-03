module d2d.ComponentGroup;

import std.algorithm;
public import d2d.Component;

/**
 * A ComponentGroup is just a way of grouping a bunch of related components into one singular group
 * From there, a ComponentGroup functions exactly as any other normal component would
 * Unexpected behaviour may stem if the components in the component group aren't all of the same Display
 */
class ComponentGroup : Component {

    Component[] subComponents; ///The components that are in this ComponentGroup

    /**
     * Scales the locations of all of the sub components to ensure the size of this group is the new location
     */
    override @property void location(iRectangle location) {
        //TODO: scale component locations based on new location
    }

    /**
     * Gets the location of this group as the smallest rectangle that contains all components
     */
    override @property iRectangle location() {
        //TODO: get the size of this by finding the smallest rectangle that contains all subComponents
        return null;
    }

    /**
     * Creates a ComponentGroup given the component-required Display as well as what sub components are in the group
     * Unexpected behaviour may stem if the components in the component group aren't all of the same Display
     */
    this(Display container, Component[] subComponents) {
        super(container);
        this.subComponents = subComponents;
    }

    /**
     * The group handles events by sending events to the sub components
     * Components recieve events in the same order they are in the group
     */
    void handleEvent(SDL_Event event) {
        this.subComponents.each!(component => component.handleEvent(event));
    }

    /**
     * The group handles drawing by just drawing all of the sub components
     * Components are drawn in the order they are in the group; later components go on top of earlier components
     */
    override void draw() {
        this.subComponents.each!(component => component.draw());
    }

}
