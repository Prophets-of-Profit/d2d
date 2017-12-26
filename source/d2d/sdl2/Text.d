module d2d.sdl2.Text;

import std.algorithm;
import std.array;
import d2d.sdl2;

/**
 * A representation of a string in a font context
 * Similar to an array of Glyphs
 */
struct Text {

    private string text;
    private Font font;      ///The font in which to represent the Text

    /**
     * Gets the Text as the string it represents
     */
    @property string asString() {
        return this.text;
    }

    /**
     * Gets the Text as an array of characters
     * Useful for C-like text handling functions
     * Note that the output needs to be cast to char* in most cases
     */
    @property char[] asChar() {
        return this.text.dup;
    }

    /**
     * Gets the Text as an array of Glyphs
     * Useful to render messages character-by-character
     */
    @property Glyph[] asGlyph() {
        return this.asChar.map!(a => Glyph(cast(char)a, this.font)).array;
    }

    /**
     * Gets the Text as an array of UNICODE-encoded characters
     * UNICODE-encoded characters are interpreted by TTF as ushorts
     */
    @property ushort[] asUshort() {
        return this.asChar.map!(a => cast(ushort)a).array;
    }

    /**
     * A Text constructor; takes a message as a string and a font context
     */
    this(string text, Font font) {
        this.text = text;
        this.font = font;
    }
}