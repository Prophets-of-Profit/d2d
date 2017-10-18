import std.experimental.logger;
import core.thread;
import gfm.logger;
import gfm.sdl2;

class Window{

    Logger logger;
    SDL2 sdl;
    SDL2Window window;
    SDL2Renderer renderer;
    __gshared bool isRunning;

    alias window this;

    this(int width = 640, int height = 480){
        this.logger = new ConsoleLogger();
        this.sdl = new SDL2(logger);
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window, SDL_RENDERER_SOFTWARE);
        this.window.setTitle("Saurabh Totey Demo");
        this.clear();
    }

    ~this(){
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
    }

    void clear(){
        this.renderer.setViewportFull();
        this.renderer.setColor(0, 0, 0, 255);
        this.renderer.clear();
        this.renderer.present();
    }

    void run(){
        this.isRunning = true;
        while(!this.sdl.wasQuitRequested()){
            SDL_Event event;
            while(this.sdl.pollEvent(&event)){
                switch(event.type){
                    case SDL_WINDOWEVENT:{
                        switch (event.window.event){
                            case SDL_WINDOWEVENT_RESIZED:{
                                this.clear();
                                break;
                            }
                            default:break;
                        }
                        break;
                    }
                    case SDL_KEYDOWN:{
                        this.handleKey(event.key.keysym);
                        break;
                    }
                    default:break;
                }
            }
            this.renderer.present();
        }
        this.isRunning = false;
    }

    void handleKey(SDL_Keysym key){
        switch(key.sym){
            case SDLK_RETURN:{
                break;
            }
            case SDLK_UP:{
                break;
            }
            case SDLK_DOWN:{
                break;
            }
            case SDLK_LEFT:{
                break;
            }
            case SDLK_RIGHT:{
                break;
            }
            default:break;
        }
    }

}

__gshared Window mainWindow;

void main(){
    new Thread({
        mainWindow = new Window();
        mainWindow.run();
        scope(exit){
            mainWindow.destroy();
        }
    }).start();

    import std.stdio;
    while(!mainWindow.isRunning){}
    for(int i = 0; mainWindow.isRunning; i++){
        writeln(i);
        Thread.sleep(seconds(1));
    }
}
