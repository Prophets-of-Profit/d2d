module d2d.Button;

import d2d.Component;

/**
 * A predefined component that may be used as one would normally expect
 * Ensures that the mouse was clicked and released over the button
 * Button doesn't handle timing of press or anything like that
 */
class Button : Component {

    private bool _isClicked; ///An internally used flag to store whether the mouse has clicked (not released) over the button
    iRectangle _location; ///Where the button is on the screen
    void delegate() action; ///What the button should do when pressed
    Texture appearance; ///What the button looks like; texture will be stretched to completely fill location

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
    override @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Makes a button given its container, location, action, and appearance
     * No given appearance makes the button transparent
     */
    this(Display container, iRectangle location, void delegate() action, Surface appearance = null) {
        super(container);
        this._location = location;
        this.action = action;
        if (appearance !is null) {
            this.appearance = new Texture(appearance, this.container.window.renderer);
        }
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

    /**
     * How the button should be drawn
     * Draws itself in its location
     */
    override void draw() {
        if (this.appearance !is null) {
            this.container.window.renderer.copy(this.appearance, this.location);
        }
    }

}
