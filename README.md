# d2d
d2d is a lightweight game framework that is made to be easy to use.\
d2d is built off of LibSDL2 and directly ports over most SDL objects in an easy and idiomatic way.\
Currently, as the name suggests, only 2D functionality is currently being worked on. However, d2d allows for the underlying SDL to be used and substituted in, so 3D additions can easily be used alongside d2d.\
For certain functionalities, SDL DLLs are required at runtime alongside the executable as SDL is loaded dynamically.\
**Real documentation will be coming soon.**

## Basic Usage
Getting started is simple. All that is needed to get started is a display and a screen.\
These can be obtained by importing either `d2d`, `d2d.Display`, or `d2d.Screen`.\
A screen is something that represents a distinct activity or action of a program. Thusly, a screen must define `void handleEvent(SDL_Event event)`, `void draw()`, and `void onFrame()`. A screen's constructor must also call the super-constructor which takes in a display.\
Once a basic screen is defined, a display can be made. The constructor parameters for a display are `(int w, int h, SDL_WindowFlags flags = SDL_WINDOW_SHOWN, string title = "", string iconPath = null)`.\
After constructing a display, you can either run the display or set the screen. Without setting the screen, running the display wouldn't do much.\
To set the screen of a display, simply call `[your display].screen = [your screen];`. A display's screen can be changed at any time.\
Once the display is all set up, all you need to do from there is to call the display's run method (`[your display].run();`). Once that is done, the rest is up to you!

### Example
Below is an extremely basic example of simple boilerplate that could function as a skeleton to an actual program.
```D
import d2d;

class MyScreen : Screen {

    this(Display container) {
        super(container);
    }

    void handleEvent(SDL_Event event) {
    }

    override void draw() {
    }

    override void onFrame() {
    }

}

void main() {
    Display mainDisplay = new Display(640, 480, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE, "This is a test");
    mainDisplay.screen = new MyScreen(mainDisplay);
    mainDisplay.run();
}
```
For an actual demo project, visit https://github.com/SaurabhTotey/d2d-Basics.