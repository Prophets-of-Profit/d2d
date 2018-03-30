/**
 * Button
 */
module d2d.Button;

import d2d;

/**
 * A predefined component that may be used as one would normally expect
 * Ensures that the mouse was clicked and released over the button
 * Button doesn't handle timing of press or anything like that
 */
abstract class Button : Component {

    private bool _isClicked; ///An internally used flag to store whether the mouse has clicked (not released) over the button
    iRectangle _location; ///Where the button is on the screen

    /**
     * Gets whether the mouse button is held down over this button
     */
    @property bool isClicked() {
        return this._isClicked;
    }

    /**
     * Gets whether the mouse is hovering over this button
     */
    @property bool isHovered() {
        return this.location.contains(this.container.mouse.location);
    }

    /**
     * Gets where the button is on the screen
     */
    override @property iRectangle location() {
        return _location;
    }

    /**
     * Sets where the button is on the screen
     */
    @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Makes a button given its location
     */
    this(Display container, iRectangle location) {
        super(container);
        this._location = location;
    }

    /**
     * How the button determines when it has been pressed
     * Collects events and if the events signify the button has been pressed, calls the button's action
     */
    void handleEvent(SDL_Event event) {
        if (!this.isHovered) {
            this._isClicked = false;
            return;
        }
        if (event.type == SDL_MOUSEBUTTONDOWN && event.button.button == SDL_BUTTON_LEFT)
            this._isClicked = true;
        else if (this._isClicked && event.type == SDL_MOUSEBUTTONUP
                && event.button.button == SDL_BUTTON_LEFT) {
            this._isClicked = false;
            this.action();
        }
    }

    void action(); //What the button should do when clicked

}
