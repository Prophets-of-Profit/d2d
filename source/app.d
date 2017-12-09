import d2d.sdl2;
import d2d.Display;

/**
 * This screen is complete garbage only for testing purposes
 */
class TestScreen : Screen{
    import std.random;
    int xVel;
    int yVel;
    iRectangle rect;
    void load(){
        this.xVel = uniform(0, 21) - 10;
        this.yVel = uniform(0, 21) - 10;
        this.rect = new iRectangle(uniform(0, this.container.window.size.x - 100), uniform(0, this.container.window.size.y - 100), 100, 100);
    }
    this(Display d){
        super(d);
        this.load();
    }
    override void onFrame(){
        //TODO test sound by playing sound on collision
        if(this.rect.topLeft.x + 100 > this.container.window.size.x || this.rect.topLeft.x < 0){
            this.xVel *= -1;
        }
        if(this.rect.topLeft.y + 100 > this.container.window.size.y || this.rect.topLeft.y < 0){
            this.yVel *= -1;
        }
        this.rect.topLeft.x += this.xVel;
        this.rect.topLeft.y += this.yVel;
    }
    override void handleEvent(SDL_Event event){
        if(event.type == SDL_MOUSEBUTTONDOWN){
            this.load();
        }
        //TODO just test display mouse here instead of actually looking for a mousebuttondown event
    }
    override void draw() {
        super.draw();
        this.container.window.renderer.drawColor = Color(102, 51, 153);
        this.container.window.renderer.fillRect(this.rect);
        this.container.window.renderer.drawColor = Color();
    }
}

void main() {
    Display test = new Display(640, 480, SDL_WINDOW_RESIZABLE, "This is a TESTAROOONI!");
    test.screen = new TestScreen(test);
    test.run();
}
