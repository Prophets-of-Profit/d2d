# Welcome!

### Note
This tutorial is unfinished. Use it at your own risk.

This is the first part of a step-by-step tutorial that goes through all of the functionality in d2d, how it is used, and the various ways it can be useful. To start, we will be creating the HelloWorld-mk1 project. 

All of the example programs can be found here (TODO)

## Using Dub

d2d is a Dub registered package. It is not necessary to use Dub to use d2d, but it makes it much easier.

To initialize a Dub package, open a command prompt and go to an empty folder where you wish to create your project. Then, if Dub is installed, type `dub init`. You will be asked several questions about various specifications about your project. Enter these, and when you reach dependencies, simply type d2d as shown below.

TODO: add image

Your Dub project is then complete! It will already have started making some code for you in source. If you want to run the project, simply type dub run when in the base directory. If you want to make changes to any of the fields entered while initializing the project, they are saved in `dub.json`. 

To update to the latest d2d version, use the command `dub upgrade` and it will automatically update all dependencies to the latest version.

## SDL2 Libraries

The next thing you will need to do is download all of the SDL2 libraries. SDL2 is the graphics library which d2d builds from. If you are using linux, then there you will not need to do anything. On Windows, you will need to download all of the binaries for SDL2 (.dll files). You can find the base binaries [here](https://www.libsdl.org/download-2.0.php). Other parts of SDL2 require futher binaries, which will be linked to in respective tutorials. Simply move the binaries into the base directory of the dub package and d2d will be ready to use!

## The Display Class

See [Display.d](../wiki/Display)

Finally, we are ready to start actually using d2d. The first class you will want to use with d2d is the Display class. Display handles the main game loop and incoming events. More details on how to use the display will be discussed in the future, but for now, we will focus on creating the display.

To create a Display, we can use the following code:
```D
import d2d;

void main() {
    Display myDisplay = new Display(640, 480, SDL_WINDOW_SHOWN, 0, "Hello World!", null);
}
```

This code will initialize a window of width 640 and height 480 with the title "Hello World!". There are several parameters left unexplained, so let's remedy that. First, SDL_WINDOW_SHOWN. This is an SDL Window Flag, which have various functions on the window. Below is a list of all of the SDL Window Flags:

|Flag|Description|
|-|-|
|SDL_WINDOW_FULLSCREEN|Creates a fullscreen window.|
|SDL_WINDOW_FULLSCREEN_DESKTOP|Creates a fullscreen window with the desktop's current resolution.|
|SDL_WINDOW_OPENGL|Makes the window usable with OpenGL, another graphics library.|
|SDL_WINDOW_SHOWN|Makes the window visible. This is the only flag which exists by default in d2d.|
|SDL_WINDOW_HIDDEN|The opposite of SDL_WINDOW_SHOWN.|
|SDL_WINDOW_BORDERLESS|Removes all of the borders and taskbar icon of the window.|
|SDL_WINDOW_RESIZABLE|Allows the window to be resized.|
|SDL_WINDOW_MINIMIZED|The window initializes minimized.|
|SDL_WINDOW_MAXIMIZED|The window initializes with the monitor's dimensions.|
|SDL_WINDOW_INPUT_GRABBED|Locks inputs (including the mouse) to the window.|
|SDL_WINDOW_INPUT_FOCUS|Checks for keyboard inputs even when the window is not active.|
|SDL_WINDOW_MOUSE_FOCUS|Checks for mouse inputs even when the window is not active.|
|SDL_WINDOW_FOREIGN|SDL is not used to create the window.|
|SDL_WINDOW_ALLOW_HIGHDPI|Enables high DPI (dots per inch) if supported by the monitor.|
|SDL_WINDOW_MOUSE_CAPTURE|Allows for mouse events to be captured when the window is not active.|
|SDL_WINDOW_ALWAYS_ON_TOP|The window will always be on top of other windows.|
|SDL_WINDOW_SKIP_TASKBAR|The window will not be added to the taskbar.|
|SDL_WINDOW_UTILITY|Treats the window as a utility window.|
|SDL_WINDOW_TOOLTIP|Treats the window as a tooltip.|
|SDL_WINDOW_POPUP_MENU|Treats the window as a popup.|

After the window flags come the renderer flags. The renderer flags will be discussed later in further detail. To have no flags, use 0 as the parameter. To use multiple flags, use the unary or operator ( | ). For example, `SDL_WINDOW_SHOWN|SDL_WINDOW_RESIZABLE`.

The next parameter is the window's title. In this example, the title is set to "Hello World!". The final parameter is an icon for the window on the taskbar, passed in as a directory for the image used for the icon. Once you have constructed your window, enter the line of code `display.run()`. Then, your program should run! 

This concludes the first d2d tutorial. The next tutorial will teach the Screen class.
