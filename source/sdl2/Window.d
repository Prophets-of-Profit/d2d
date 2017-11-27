module d2d.sdl2.Window;

import std.algorithm;
import std.array;
import std.conv;
import std.string;
import d2d.sdl2;

/**
 * A window is, as it name suggests, a window
 * This window class is extremely minimalistic and is a port of the SDL_Window
 */
class Window {

    private SDL_Window* window;
    private Surface windowSurface;
    private Renderer windowRenderer;
    private Surface windowIcon;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Window* handle() {
        return this.window;
    }

    /**
     * Sets the window's brightness or gama multiplier
     */
    @property void brightness(float b) {
        ensureSafe(SDL_SetWindowBrightness(this.window, b));
    }

    /**
     * Gets the window's brightness or gama multiplier
     */
    @property float brightness() {
        return SDL_GetWindowBrightness(this.window);
    }

    /**
     * Sets the display mode of this window
     */
    @property void displayMode(SDL_DisplayMode dMode) {
        ensureSafe(SDL_SetWindowDisplayMode(this.window, &dMode));
    }

    /**
     * Gets the display mode of this window
     */
    @property SDL_DisplayMode displayMode() {
        SDL_DisplayMode dMode;
        ensureSafe(SDL_GetWindowDisplayMode(this.window, &dMode));
        return dMode;
    }

    /**
     * Sets whether the window grabs input or not
     */
    @property void grab(bool g) {
        SDL_SetWindowGrab(this.window, g ? SDL_TRUE : SDL_FALSE);
    }

    /**
     * Gets whether the window grabs input or not
     */
    @property bool grab() {
        return SDL_GetWindowGrab(this.window) == SDL_TRUE;
    }

    /**
     * Sets the window's maximum size
     */
    @property void maximumSize(iPoint maxSize) {
        SDL_SetWindowMaximumSize(this.window, maxSize.x, maxSize.y);
    }

    /**
     * Gets the window's maximum size
     */
    @property iPoint maximumSize() {
        iPoint maxSize = new iPoint(0, 0);
        SDL_GetWindowMaximumSize(this.window, &maxSize.x, &maxSize.y);
        return maxSize;
    }

    /**
     * Sets the window's minimum size
     */
    @property void minimumSize(iPoint minSize) {
        SDL_SetWindowMinimumSize(this.window, minSize.x, minSize.y);
    }

    /**
     * Gets the window's minimum size
     */
    @property iPoint minimumSize() {
        iPoint minSize = new iPoint(0, 0);
        SDL_GetWindowMinimumSize(this.window, &minSize.x, &minSize.y);
        return minSize;
    }

    /**
     * Sets the window's size
     */
    @property void size(iPoint s) {
        SDL_SetWindowSize(this.window, s.x, s.y);
    }

    /**
     * Gets the window's size
     */
    @property iPoint size() {
        iPoint s = new iPoint(0, 0);
        SDL_GetWindowSize(this.window, &s.x, &s.y);
        return s;
    }

    /**
     * Sets the window's opacity
     */
    @property void opacity(float o) {
        ensureSafe(SDL_SetWindowOpacity(this.window, o));
    }

    /**
     * Gets the window's opacity
     */
    @property float opacity() {
        float o;
        ensureSafe(SDL_GetWindowOpacity(this.window, &o));
        return o;
    }

    /**
     * Sets the window's screen position
     */
    @property position(iPoint pos) {
        SDL_SetWindowPosition(this.window, pos.x, pos.y);
    }

    /**
     * Gets the window's screen position
     */
    @property iPoint position() {
        iPoint pos;
        SDL_GetWindowPosition(this.window, &pos.x, &pos.y);
        return pos;
    }

    /**
     * Sets the window's title
     */
    @property void title(string newTitle) {
        SDL_SetWindowTitle(this.window, newTitle.toStringz);
    }

    /**
     * Gets the window's title
     */
    @property string title() {
        return SDL_GetWindowTitle(this.window).to!string;
    }

    /**
     * Sets the window's icon
     */
    @property void icon(Surface i) {
        this.windowIcon = i;
        SDL_SetWindowIcon(this.window, i.handle);
    }

    /**
     * Gets the window's icon
     */
    @property Surface icon() {
        return this.windowIcon;
    }

    /**
     * Gets the information about the window
     * Returns an array of all the flags that describe this window
     */
    @property SDL_WindowFlags[] info() {
        immutable SDL_WindowFlags[] allPossibleFlags = [
            SDL_WINDOW_FULLSCREEN, SDL_WINDOW_FULLSCREEN_DESKTOP, SDL_WINDOW_OPENGL,
            SDL_WINDOW_SHOWN, SDL_WINDOW_HIDDEN, SDL_WINDOW_BORDERLESS,
            SDL_WINDOW_RESIZABLE, SDL_WINDOW_MINIMIZED, SDL_WINDOW_MAXIMIZED,
            SDL_WINDOW_INPUT_GRABBED,
            SDL_WINDOW_INPUT_FOCUS,
            SDL_WINDOW_MOUSE_FOCUS, SDL_WINDOW_FOREIGN, SDL_WINDOW_ALLOW_HIGHDPI,
            SDL_WINDOW_MOUSE_CAPTURE, SDL_WINDOW_ALWAYS_ON_TOP, SDL_WINDOW_SKIP_TASKBAR,
            SDL_WINDOW_UTILITY, SDL_WINDOW_TOOLTIP, SDL_WINDOW_POPUP_MENU
        ];
        immutable uint windowFlags = SDL_GetWindowFlags(this.window);
        return allPossibleFlags.filter!(flag => flag & windowFlags).array.dup;
    }

    /**
     * Gets the window's surface
     */
    @property Surface surface() {
        return this.windowSurface;
    }

    /** 
     * Gets the window's renderer
     */
    @property Renderer renderer() {
        return this.windowRenderer;
    }

    /**
     * Constructor for a window; needs at least a width and a height
     */
    this(int w, int h, SDL_WindowFlags flags = 0.to!SDL_WindowFlags, string title = "",
            int x = SDL_WINDOWPOS_CENTERED, int y = SDL_WINDOWPOS_CENTERED) {
        this.window = SDL_CreateWindow(title.toStringz, x, y, w, h, flags);
        this.windowSurface = new Surface(ensureSafe(SDL_GetWindowSurface(this.window)));
        this.windowRenderer = new Renderer(ensureSafe(SDL_GetRenderer(this.window)));
    }

    /**
     * Creates the window from an already existing SDL_Window
     */
    this(SDL_Window* alreadyExisting) {
        this.window = alreadyExisting;
        this.windowSurface = new Surface(ensureSafe(SDL_GetWindowSurface(this.window)));
        this.windowRenderer = new Renderer(ensureSafe(SDL_GetRenderer(this.window)));
    }

    /**
     * Ensures that SDL can properly dispose of the window
     */
    ~this() {
        SDL_DestroyWindow(this.window);
    }

    /**
     * Marks the current window as a modal for the given parent window
     */
    void setAsModalFor(Window parent) {
        ensureSafe(SDL_SetWindowModalFor(this.window, parent.handle));
    }

    /**
     * Sets whether the window should be bordered or not
     * Is not a property method because it is a setter without a getter
     */
    void setBordered(bool borderedStatus) {
        SDL_SetWindowBordered(this.window, borderedStatus ? SDL_TRUE : SDL_FALSE);
    }

    /**
     * Sets whether the window should be resizable or not
     * Is not a property method because it is a setter without a getter
     */
    void setResizable(bool resizability) {
        SDL_SetWindowResizable(this.window, resizability ? SDL_TRUE : SDL_FALSE);
    }

    /**
     * Hides the window
     */
    void hide() {
        SDL_HideWindow(this.window);
    }

    /**
     * Shows the window
     */
    void show() {
        SDL_ShowWindow(this.window);
    }

    /**
     * Maximizes the window
     */
    void maximize() {
        SDL_MaximizeWindow(this.window);
    }

    /**
     * Minimizes window in terms of size
     */
    void minimize() {
        SDL_MinimizeWindow(this.window);
    }

    /**
     * Restores a window to its original state before a maximize or minimize
     */
    void restore() {
        SDL_RestoreWindow(this.window);
    }

    /**
     * Moves the window to be on top of everything else and to have the focus
     */
    void raise() {
        SDL_RaiseWindow(this.window);
    }

}
