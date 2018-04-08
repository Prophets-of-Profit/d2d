module source.d2d.DynamicPanel;

import d2d;

/**
 * A component which supports panning, zooming, and rotaion
 * TODO: implement zoom and rotation
 */
class DynamicPanel : Component {

    Texture texture; ///The texture to be drawn
    iRectangle _location; ///The location of the panel
    iVector panAmount; ///The distance the object is panned

    /**
     * A property to return the panel's location
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the panel's location
     */
    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Constructs a new dynamic panel
     */
    this(Display container, iRectangle location, Texture texture) {
        super(container);
        this._location = location;
        this.texture = texture;
        this.panAmount = new iVector(0, 0);
    }

    /**
     * Changes the location of the pan 
     */
    void changePan(iVector change) {
        this.panAmount += change;
    }

    /**
     * Sets the pan to the given amount
     */
    void setPan(iVector amount) {
        this.panAmount = amount;
    }

    override void draw() {
        this.container.renderer.copy(this.texture, this._location, new iRectangle(this.location.initialPoint.x + 
                this.panAmount.x, this.location.initialPoint.y + this.panAmount.y, this.location.extent.x + 
                this.panAmount.x, this.location.extent.y + this.panAmount.y));
    }

    void handleEvent(SDL_Event event) {}

}