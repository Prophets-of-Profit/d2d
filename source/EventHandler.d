module d2d.EventHandler;

import d2d.sdl2;

/**
 * An interface that just defines an object that can collect and respond to sdl events
 * Event handlers can be added to a display to add unique behaviour for events
 */
interface EventHandler {

    void handleEvent(SDL_Event event); ///Takes in an SDL event and should define what behaviour should happen for specific events

}
