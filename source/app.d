import d2d.sdl2;
import d2d.Display;

/**
 * This screen is complete garbage only for testing purposes
 */
class TestScreen : Screen {

    import std.datetime.stopwatch;
    import std.random;
    import std.stdio;

    int xVel; ///X velocity of the square
    int yVel; ///Y velcity of the square
    iRectangle rect; ///The actual squre itself that gets rendered
    ulong frames; ///How many frames have passed; used for framerate recording purposes
    StopWatch timer; ///A timer to measure how much time has elapsed; used for framerate recording purposes

    /**
     * Sets the square in a random location with a random velocity
     */
    void load() {
        this.xVel = uniform(0, 21) - 10;
        this.yVel = uniform(0, 21) - 10;
        this.rect = new iRectangle(uniform(0, this.container.window.size.x - 100),
                uniform(0, this.container.window.size.y - 100), 100, 100);
    }

    /**
     * Constructs this screen and starts the timer and loads the square
     */
    this(Display d) {
        super(d);
        this.timer = StopWatch(AutoStart.no);
        this.timer.start();
        this.load();
    }

    /**
     * What this screen does on every frame
     * Does some calculations for framerate and moves the square according to its velocity
     */
    override void onFrame() {
        this.frames++;
        if (this.timer.peek() >= seconds(1)) {
            writeln(1000 * this.frames / this.timer.peek().total!"msecs");
            this.frames = 0;
            this.timer.reset();
        }
        //TODO test sound by playing sound on collision
        if (this.rect.topLeft.x + 100 > this.container.window.size.x || this.rect.topLeft.x < 0) {
            this.xVel *= -1;
        }
        if (this.rect.topLeft.y + 100 > this.container.window.size.y || this.rect.topLeft.y < 0) {
            this.yVel *= -1;
        }
        this.rect.topLeft.x += this.xVel;
        this.rect.topLeft.y += this.yVel;
    }

    /**
     * How the screen reacts to events
     * Only reloads the square on a mouse click
     */
    override void handleEvent(SDL_Event event) {
        if (event.type == SDL_MOUSEBUTTONDOWN) {
            this.load();
        }
        //TODO just test display mouse here instead of actually looking for a mousebuttondown event
    }

    /**
     * Actually draws the square on the screen
     */
    override void draw() {
        super.draw();
        this.container.window.renderer.drawColor = Color(102, 51, 153);
        this.container.window.renderer.fillRect(this.rect);
        this.container.window.renderer.drawColor = Color();
    }

}

void main() {
    Display testDisplay = new Display(640, 480, SDL_WINDOW_RESIZABLE, "This is a TESTAROOONI!");
    testDisplay.screen = new TestScreen(testDisplay);
    testDisplay.run();
}
