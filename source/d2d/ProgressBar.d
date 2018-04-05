module source.d2d.ProgressBar;

import d2d;

/**
 * A progress bar to be displayed at any point on the screen
 * Fills from left to right its progress
 * TODO: allow bar direction to be modified
 */
class ProgressBar(T) : Component {

    iRectangle _location; ///The location and dimensions of the bar
    T maxVal; ///The maximum value of the quantity measured
    T currentVal; ///The current value of the quantity measured
    Color backColor; ///The background color of the bar
    Color foreColor; ///The forground color of the bar

    /**
     * Constructs a new health bar at the given location with the given values
     */
    this(Display container, iRectangle location, Color backColor, Color foreColor, T maxVal, 
            T currentVal = 0) {
        super(container);
        this._location = location;
        this.backColor = backColor;
        this.foreColor = foreColor;
        this.maxVal = maxVal,
        this.currentVal = currentVal;
    }

    /**
     * Returns the location of the progress bar
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the location of the progress bar
     */
    override @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Draws the progress bar to the screen
     */
    override void draw() {
        this.container.renderer.fillRect(this._location, this.backColor);
        if(this.currentVal >= 0) {
            this.container.renderer.fillRect(new iRectangle(this._location.x, this._location.y, 
                    cast(int)(this._location.w * (this.currentVal / this.maxVal)), this._location.h), this.foreColor);
        }
    }

}