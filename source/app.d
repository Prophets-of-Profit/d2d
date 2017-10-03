import core.thread;
import derelict.sdl2.sdl;

shared static this(){
    DerelictSDL2.load(SharedLibVersion(2, 0, 6));
    SDL_Init(SDL_INIT_VIDEO);
}

class Window{

    private SDL_Window* window;
    private SDL_Surface* mainSurface;
    __gshared bool isRunning = true;

    @property int width(){
        int w;
        SDL_GetWindowSize(this.window, &w, null);
        return w;
    }

    @property int width(int w){
        SDL_SetWindowSize(this.window, w, this.height);
        return this.width;
    }

    @property int height(){
        int h;
        SDL_GetWindowSize(this.window, null, &h);
        return h;
    }

    @property int height(int h){
        SDL_SetWindowSize(this.window, this.width, h);
        return this.height;
    }

    this(int width, int height){
        this.window = SDL_CreateWindow("Saurabh Totey - Test", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN);
        this.mainSurface = SDL_GetWindowSurface(this.window);
    }

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

__gshared Window mainWindow;

void main(){
    new Thread({
        mainWindow = new Window(640, 480);
        mainWindow.run();
    }).start();
    import std.stdio;
    for(int i = 0; mainWindow.isRunning; i++){
        writeln(i);
    }
}
