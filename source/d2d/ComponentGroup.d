module d2d.ComponentGroup;

import std.algorithm;
import d2d;

/**
 * A ComponentGroup is just a way of grouping a bunch of related components into one singular group
 * From there, a ComponentGroup functions exactly as any other normal component would
 * Unexpected behaviour may stem if the components in the component group aren't all of the same Display
 */
class ComponentGroup : Component {

    Component[] subComponents; ///The components that are in this ComponentGroup

    /**
     * Gets the location of this group as the smallest rectangle that contains all components
     */
    override @property iRectangle location() {
        iVector minValue = new iVector(int.max);
        iVector maxValue = new iVector(int.min);
        foreach (component; this.subComponents) {
            if (component.location.x < minValue.x) {
                minValue.x = component.location.x;
            }
            if (component.location.y < minValue.y) {
                minValue.y = component.location.y;
            }
            if (component.location.x + component.location.w > maxValue.x) {
                maxValue.x = component.location.x + component.location.w;
            }
            if (component.location.y + component.location.h > maxValue.y) {
                maxValue.y = component.location.y + component.location.h;
            }
        }
        iVector difference = maxValue - minValue;
        return new iRectangle(minValue.x, minValue.y, difference.x, difference.y);
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
