module d2d.sdl2.Color;

import d2d.sdl2;

/**
 * A color struct
 * As of right now, only works with additive RGBA, but may work with other formats later
 * Additive RGBA is where the color is stored as an addition of red, green, and blue
 * Alpha is the transparency of the color
 */
struct Color {
    ubyte r; ///Red value for the color
    ubyte g; ///Green value for the color
    ubyte b; ///Blue value for the color
    ubyte a = 255; ///Alpha value or transparency for the color
    private SDL_Color sdlColor;

    /**
     * Gets the color as an SDL_Color
     */
    @property SDL_Color* handle() {
        sdlColor = SDL_Color(r, g, b, a);
        return &sdlColor;
    }
}

/**
 * A list of pre-defined common colors
 */
enum PredefinedColor {
    RED = Color(255, 0, 0),
    GREEN = Color(0, 255, 0),
    BLUE = Color(0, 0, 255),
    YELLOW = Color(255, 255, 0),
    MAGENTA = Color(255, 0, 255),
    CYAN = Color(0,
            255, 255),
    WHITE = Color(255, 255, 255),
    PINK = Color(255, 125, 255),
    ORANGE = Color(255, 125, 0),
    LIGHTGREY = Color(175, 175, 175),
    DARKGREY = Color(75, 75, 75),
    BLACK = Color(0, 0, 0)
}
