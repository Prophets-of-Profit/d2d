import d2d.sdl2;
import d2d.Display;

/**
 * This screen is complete garbage only for testing purposes
 */
class Stuff : Screen{
    double i = 0;
    this(Display d){
        super(d);
    }
    override void onFrame(){
        i += 0.5;
    }
    override void handleEvent(SDL_Event event){}
    override void draw() {
        super.draw();
        this.container.window.renderer.drawColor = Color(255, 0, 0);
        this.container.window.renderer.fillRect(new iRectangle(cast(int) this.i, cast(int) this.i, 100, 100));
        this.container.window.renderer.drawColor = Color();
    }
}

void main() {
    Display test = new Display(640, 480, SDL_WINDOW_RESIZABLE, "This is a TESTAROOONI!");
    test.screen = new Stuff(test);
    test.run();
}
