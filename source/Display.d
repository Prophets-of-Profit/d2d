module d2d.Display;

import std.algorithm;
import std.conv;
import std.datetime;
import d2d.EventHandler;
import d2d.Keyboard;
import d2d.Mouse;
public import d2d.Screen;
import d2d.sdl2;

/**
 * A display that handles collecting events and drawing to the screen and handling window stuff
 * Will handle the main loop and send events to where they need to be handled
 */
class Display {

    int framerate = 60; ///The framerate of the window. TODO If negative, it will be vsync
    ulong frames; ///How many frames have passed
    bool isRunning; ///Whether the display is running; will stop running if set to false
    void delegate() periodicAction; ///What the display should do every tick (usually faster or more often than a frame)
    Screen screen; ///The screen that the display is displaying right now
    EventHandler[] eventHandlers; ///All event handlers of the display; define specific behaviours for events; events pass to handlers from first to last
    private Keyboard _keyboard = new Keyboard(); ///The keyboard input source
    private Mouse _mouse = new Mouse(); ///The mouse input source
    private Window _window; ///The actual SDL window

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
     * Constructs a display
     */
    this(int w, int h, SDL_WindowFlags flags = SDL_WINDOW_SHOWN,
            string title = "", string iconPath = null) {
        this._window = new Window(w, h, flags, title);
        if (iconPath !is null && iconPath != "") {
            this.window.icon = d2d.sdl2.Surface.loadImage(iconPath);
        }
    }

    /**
     * Actually runs the display and handles event collection and framerate and most other things
     */
    void run() {
        this.isRunning = true;
        SysTime lastTickTime;
        while (this.isRunning) {
            SDL_Event event;
            while (SDL_PollEvent(&event) != 0) {
                switch (event.type) {
                case SDL_QUIT:
                    this.isRunning = false;
                    goto default;
                case SDL_MOUSEBUTTONDOWN:
                case SDL_MOUSEBUTTONUP:
                case SDL_MOUSEMOTION:
                case SDL_MOUSEWHEEL:
                    this.mouse.handleEvent(event);
                    goto default;
                case SDL_KEYDOWN:
                case SDL_KEYUP:
                    this.keyboard.handleEvent(event);
                    goto default;
                default:
                    this.eventHandlers.each!(handler => handler.handleEvent(event));
                    if(this.screen !is null) {
                        this.screen.handleEvent(event);
                    }
                    break;
                }
            }
            if (this.periodicAction !is null) {
                this.periodicAction();
            }
            if(this.screen !is null) {
                this.screen.draw();
            }
            if (this.window.renderer.info.flags & SDL_RENDERER_PRESENTVSYNC
                    || Clock.currTime >= lastTickTime + dur!"msecs"((1000.0 / this.framerate)
                        .to!int)) {
                this.screen.onFrame();
                this.window.renderer.present();
                lastTickTime = Clock.currTime;
                this.frames++;
            }
        }
    }

}
