module d2d.Utility;

import derelict.sdl2.sdl;

/**
 * A color struct
 * As of right now, only works with additive RGBA, but may work with other formats later
 * Additive RGBA is where the color is stored as an addition of red, green, and blue
 * Alpha is the transparency of the color
 */
struct Color{
    ubyte r;            ///Red value for the color
    ubyte g;            ///Green value for the color
    ubyte b;            ///Blue value for the color
    ubyte a= 255;       ///Alpha value or transparency for the color
    alias handle this;  ///Makes the color accessible as an SDL_Color which is almost the same thing

    /**
     * Gets the color as an SDL_Color
     */
    @property SDL_Color handle(){
        return SDL_Color(r, g, b, a);
    }
}

/**
 * A point is a location in 2d space
 * Location is accessed by x and y coordinates
 */
struct Point (T) if(__traits(isScalar,T)){
    T x;    ///X value of the point
    T y;    ///Y value of the point
}

alias iPoint = Point!int;     ///Allows integer points to be accessed as iPoint
alias dPoint = Point!double;  ///Allows double points to be accessed as dPoint
alias fPoint = Point!float;   ///Allows float points to be accessed as fPoint

/**
 * A rectangle is a box in 2d space
 * This struct only does Axis Aligned Bounding Boxes (AABB) which don't have rotation
 */
class Rectangle{
    iPoint topLeft;         ///The top left point of the rectangle
    int w;                  ///The width of the rectangle
    int h;                  ///The height of the rectangle
    alias handle this;      ///Makes the rectangle accessible as an SDL_Rect which is almost the same thing
    
    /**
     * Gets the rectangle as an SDL_Rect
     */
    @property SDL_Rect handle(){
        return SDL_Rect(topLeft.x, topLeft.y, w, h);
    }

}