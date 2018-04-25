module d2d.sdl2.ShapeDrawer;

import std.algorithm;
import d2d.math;
import d2d.sdl2;

/**
 * A utility class to provide math drawing utilities
 */
abstract class ShapeDrawer {

    /**
     * A shape drawer needs drawing a point to be defined
     */
    void draw(int x, int y);

    /**
     * Draws a point given by a vector
     */
    void draw(iVector point) {
        this.draw(point.x, point.y);
    }

    /**
     * Draws a line given by two points
     */
    void draw(iVector first, iVector second) {
        iVector difference = second - first;
        immutable slope = difference.y / difference.x;
        foreach (x; first.x .. second.x + 1) {
            this.draw(x, first.y + slope * (x - first.x));
        }
    }

    /**
     * Draws a line given by a segment
     */
    void draw(iSegment line) {
        this.draw(line.initial, line.terminal);
    }

    /**
     * Draws the given rectangle
     */
    void draw(iRectangle rect) {
        foreach (edge; rect.edges) {
            this.draw(edge);
        }
    }

    /**
     * Fills the given rectangle
     */
    void fill(iRectangle rect) {
        int[2] xBounds = [rect.initialPoint.x, rect.bottomRight.x];
        foreach(y; rect.initialPoint.y .. rect.bottomRight.y + 1) {
            this.draw(new iVector(xBounds[0], y), new iVector(xBounds[1], y));
        }
    }

}
