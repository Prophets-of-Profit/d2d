module d2d.math.Segment;

/**
 * A segment class that is defined by two 
 */
class Segment(T, ulong dimensions) {

    Vector!(T, dimensions) initial; ///The initial point (the vector points to the initial point)
    Vector!(T, dimensions) terminal; ///The terminal point (the vector points to the terminal point)

    /**
     * Returns the direction of the segment from initial to terminal
     */
    @property Vector!(T, dimensions) direction() {
        return terminal - initial;
    }

    /**
     * Constructor for a segment;
     * Takes in the initial point and the terminal point
     */
    this(Vector!(T, dimensions) initial, Vector!(T, dimensions) terminal) {
        this.initial = initial;
        this.terminal = terminal;
    }

    /**
     * TODO: return whether this segment intersects the other segment
     */
    bool intersects(U)(Segment!(U, dimensions) other) {
        return false;
    }

    /**
     * TODO: return whether this segment contains the other point
     */
    bool contains(T)(Vector!(T, dimensions) point) {
        return false;
    }

}
