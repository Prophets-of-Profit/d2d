module d2d.sdl2.Window;

public import derelict.sdl2.sdl;

/**
 * A window is, as it name suggests, a window
 * This window class is extremely minimalistic and is a port of the SDL_Window
 */
class Window{

    private SDL_Window* window;

    /**
     * Returns the raw SDL data of this object
     */
    @property SDL_Window* handle(){
        return this.window;
    }

    /**
     * Ensures that SDL can properly dispose of the window
     */
    ~this(){
        SDL_DestroyWindow(this.window);
    }

}