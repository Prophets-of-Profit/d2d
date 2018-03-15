# d2d
d2d is a lightweight game framework that is made to be easy to use.\
d2d is built off of LibSDL2 and directly ports over most SDL objects in an easy and idiomatic way.\
Currently, as the name suggests, only 2D functionality is currently being worked on. However, d2d allows for the underlying SDL to be used and substituted in, so 3D additions can easily be used alongside d2d.\
For certain functionalities, SDL DLLs are required at runtime alongside the executable as SDL is loaded dynamically.\
**Real documentation will be coming soon.**

## Basic Usage
Getting started is simple. All that is needed to get started is a display and an activity.\
These can be obtained by importing either `d2d`, `d2d.Display`, or `d2d.Activity`.\
An activity is something that represents a distinct activity or action of a program. Thusly, an activity can define `void handleEvent(SDL_Event event)`, `void draw()`, and `void update()`. A activity's constructor must also call the super-constructor which takes in a display.\
Once a basic activity is defined, a display can be made. The constructor parameters for a display are `(int w, int h, SDL_WindowFlags flags = SDL_WINDOW_SHOWN, uint rendererFlags = 0, string title = "", string iconPath = null)`.\
After constructing a display, you can either run the display or set the activity. Without setting the activity, running the display wouldn't do much.\
To set the activity of a display, simply call `[your display].activity = [your activity];`. A display's activity can be changed at any time.\
Once the display is all set up, all you need to do from there is to call the display's run method (`[your display].run();`). Once that is done, the rest is up to you!\
A display can have its activity changed at any time if the program requires.

### Example
Below is an extremely basic example of simple boilerplate that could function as a skeleton to an actual program.
```D
import d2d;

/**
 * All the methods defined in this class are optional EXCEPT for the constructor
 */
class MyActivity : Activity {

    this(Display container) {
        super(container);
    }

    override void handleEvent(SDL_Event event) {
    }

    override void draw() {
    }

    override void update() {
    }

}

void main() {
    Display mainDisplay = new Display(640, 480, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE, 0, "Window Title!");
    mainDisplay.activity = new MyActivity(mainDisplay);
    mainDisplay.run();
}
```
For an actual demo project, visit https://github.com/SaurabhTotey/d2d-Basics. \
For tutorials, you can look at https://github.com/KadinTucker/d2d-tutorials.
