module d2d.Display;

import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import core.thread;
import d2d.EventHandler;
import d2d.Keyboard;
import d2d.Mouse;
public import d2d.Screen;
public import d2d.sdl2;

/**
 * A display that handles collecting events and drawing to the screen and handling window stuff
 * Will handle the main loop and send events to where they need to be handled
 */
class Display {

    int framerate = 60; ///The framerate of the window. Will be ignored if the renderer is VSync
    bool isRunning; ///Whether the display is running; will stop running if set to false
    Screen screen; ///The screen that the display is displaying right now
    EventHandler[] eventHandlers; ///All event handlers of the display; define specific behaviours for events; events pass to handlers from first to last
    private ulong _frames; ///How many frames have passed
    private Keyboard _keyboard = new Keyboard(); ///The keyboard input source
    private Mouse _mouse = new Mouse(); ///The mouse input source
    private Window _window; ///The actual SDL window

    /**
     * Gets how many frames have passed since the window started
     */
    @property ulong frames() {
        return this._frames;
    }

    /**
     * Gets the keyboard of the display
     */
    @property Keyboard keyboard() {
        return this._keyboard;
    }

    /**
     * Gets the mouse of the display
     */
    @property Mouse mouse() {
        return this._mouse;
    }

    /**
     * Gets the window of the display
     */
    @property Window window() {
        return this._window;
    }

    /**
     * Constructs a display given a width, height, window flags, a title, a path for an image icon (or null), and renderer flags
     */
    this(int w, int h, SDL_WindowFlags flags = SDL_WINDOW_SHOWN, string title = "",
            string iconPath = null, uint rendererFlags = 0) {
        this._window = new Window(w, h, flags, title, rendererFlags);
        if (iconPath !is null && iconPath != "") {
            this.window.icon = loadImage(iconPath);
        }
    }

    /**
     * Actually runs the display and handles event collection and framerate and most other things
     */
    void run() {
        this.isRunning = true;
        StopWatch timer = StopWatch(AutoStart.yes);
        while (this.isRunning) {
            timer.reset();
            SDL_Event event;
            while (SDL_PollEvent(&event) != 0) {
                if (event.type == SDL_QUIT) {
                    this.isRunning = false;
                }
                this.mouse.handleEvent(event);
                this.keyboard.handleEvent(event);
                this.eventHandlers.each!(handler => handler.handleEvent(event));
                if (this.screen !is null) {
                    this.screen.components.each!(component => component.handleEvent(event));
                    this.screen.handleEvent(event);
                }
            }
            if (this.screen !is null) {
                this.screen.draw();
                this.screen.components.each!(component => component.draw());
            }
            this.screen.onFrame();
            this.window.renderer.present();
            this._frames++;
            if (this.window.renderer.info.flags & SDL_RENDERER_PRESENTVSYNC) {
                continue;
            }
            immutable sleepTime = 1000 / this.framerate - timer.peek().total!"msecs";
            if (sleepTime > 0) {
                Thread.sleep(msecs(sleepTime));
            }
        }
    }

}
