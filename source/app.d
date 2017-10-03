/**
 * A demo that is just a collection of base code for a LibSDL2 application
 * Is specifically made so the window runs in a separate thread
 * Extremely bare-bones and basic code
 */

//Threading is used so that the window can be used in conjunction with actual logic running concurrently
import core.thread;
//LibSDL2 is used for a window and for the base graphics
import derelict.sdl2.sdl;

/**
 * Code that only needs to be run once in the entire lifetime of the program
 * Loads LibSDL2 with the version of 2.0.6, and initializes LibSDL2 video
 */
shared static this(){
    DerelictSDL2.load(SharedLibVersion(2, 0, 6));
    SDL_Init(SDL_INIT_VIDEO);
}

/**
 * A class for a window
 * Has methods for basic window behaviour and handles SDL stuff internally
 */
class Window{

    ///The actual SDL window that this class represents
    private SDL_Window* window;
    ///The surface of the window
    private SDL_Surface* mainSurface;
    ///Whether the window is currently active; this field is accessible anywhere on any thread
    __gshared bool isRunning = true;

    /**
     * Gets the width of the window dynamically, but is acccessed as a field
     */
    @property int width(){
        int w;
        SDL_GetWindowSize(this.window, &w, null);
        return w;
    }

    /**
     * Sets the width of the window, but is accessed as a field
     */
    @property int width(int w){
        SDL_SetWindowSize(this.window, w, this.height);
        return this.width;
    }

    /**
     * Gets the height of the window dynamically, but is accessed as a field
     */
    @property int height(){
        int h;
        SDL_GetWindowSize(this.window, null, &h);
        return h;
    }

    /**
     * Sets the height of the window, but is accessed as a field
     */
    @property int height(int h){
        SDL_SetWindowSize(this.window, this.width, h);
        return this.height;
    }

    /**
     * Constructs a window with a given width and height
     * Also grabs the window's surface and stores it in the mainSurface field
     */
    this(int width, int height){
        this.window = SDL_CreateWindow("Saurabh Totey - Test", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN);
        this.mainSurface = SDL_GetWindowSurface(this.window);
    }

    /**
     * A method that is the window's main behaviour
     * All events and actions by the user are defined here
     * This is just a demo for a possible configuration
     * Currently makes the window fullscreen when ENTER is pressed (BROKEN)
     * Also currently closes the window when the window is closed by the user or ESCAPE is pressed
     */
    void run(){
        SDL_Event event;
        while(this.isRunning){
            SDL_FillRect(this.mainSurface, null, SDL_MapRGB(this.mainSurface.format, 148, 0, 211));
            while(SDL_PollEvent(&event) != 0){
                switch(event.type){
                    case SDL_QUIT:
                        this.isRunning = false;
                        break;
                    case SDL_WINDOWEVENT:
                        break;
                    case SDL_KEYDOWN:
                        switch(event.key.keysym.sym){
                            case SDLK_RETURN:
                                SDL_SetWindowFullscreen(this.window, (SDL_GetWindowFlags(this.window) & SDL_WINDOW_FULLSCREEN)? SDL_FALSE : SDL_WINDOW_FULLSCREEN);
                                SDL_FillRect(this.mainSurface, null, SDL_MapRGB(this.mainSurface.format, 148, 0, 211));
                                SDL_UpdateWindowSurface(this.window);
                                break;
                            case SDLK_ESCAPE:
                                this.isRunning = false;
                                break;
                            default:
                                break;
                        }
                        break;
                    default:
                        break;
                }
            }
            SDL_UpdateWindowSurface(this.window);
        }
    }

}

///Globally accessible main window; is __gshared so it may be acccessed in separate threads
__gshared Window mainWindow;

/**
 * Entry point for programs in D
 */
void main(){
    //Constructs and starts a new anonymous thread with an anonymous function that constructs the window and runs it
    new Thread({
        mainWindow = new Window(640, 480);
        mainWindow.run();
    }).start();
    //Below is unneccessary, but exists just to show that the window can be used in multiple threads
    import std.stdio;
    for(int i = 0; mainWindow.isRunning; i++){
        writeln(i);
    }
}
