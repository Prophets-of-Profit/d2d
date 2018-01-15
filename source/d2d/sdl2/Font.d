module d2d.sdl2.Font;

import std.algorithm;
import std.array;
import std.conv;
import std.string;
import d2d.sdl2;

/**
 * The three types of encoding TTF can use
 * LATIN1 is the set of ASCII characters; its glyphs are represented as chars
 * UTF8 is the set of "Unicode" characters; it can handle all ASCII characters as well because ASCII is a subset of Unicode
 * UNICODE encoding is determined by operating system; Windows handles UNICODE using UTF16, while UNIX systems use UTF8
 * Note: UNICODE is identical to UTF8 in some cases but uses ushorts to represent glyps instead of using chars
 */
enum Encoding {
    LATIN1,
    UTF8,
    UNICODE
}

/**
 * Fonts are contexts for displaying strings
 * Fonts  describe how each character in the string looks and how they are spaced
 * Each font includes a collection of supported glyphs and general information
 * TODO: allow for multiline printing
 */
class Font {

    private TTF_Font* font;

    /**
     * Returns the raw SDL data of this object
     */
    @property TTF_Font* handle() {
        return this.font;
    }

    /**
     * Sets the style (bold, italic, etc.) of this font
     * Style should be inputted as a bitmask composed of:
     * TTF_STYLE_BOLD 
     * TTF_STYLE_ITALIC 
     * TTF_STYLE_UNDERLINE 
     * TTF_STYLE_STRIKETHROUGH
     * If the style is normal, use TTF_STYLE_NORMAL
     * For multiple styles, use a bitwise OR operator (TTF_STYLE_BOLD|TTF_STYLE_ITALIC means both bold and italic, etc.)
     */
    @property void style(int style) {
        TTF_SetFontStyle(this.font, style);
    }

    /**
     * Gets the style (bold, italic, etc.) of this font
     * Style is returned as a bitmask composed of:
     * TTF_STYLE_BOLD 
     * TTF_STYLE_ITALIC 
     * TTF_STYLE_UNDERLINE 
     * TTF_STYLE_STRIKETHROUGH
     * If the style is normal, the value returned will be TTF_STYLE_NORMAL
     * Otherwise, use bitwise and operations to get individual values (style&TTF_STYLE_BOLD returns whether the font is bold, etc.)
     */
    @property int style() {
        return TTF_GetFontStyle(this.font);
    }

    /**
     * Sets the size of the font's outline
     * Use outline = 0 to disable outlining
     */
    @property void outline(int outline) {
        TTF_SetFontOutline(this.font, outline);
    }

    /**
     * Gets the size of the font's outline
     * Outline is constant across glyphs in a font
     */
    @property int outline() {
        return TTF_GetFontOutline(this.font);
    }

    /**
     * Sets the font's hinting type
     * Type is taken as a value matching one of the following:
     * TTF_HINTING_NORMAL
     * TTF_HINTING_LIGHT
     * TTF_HINTING_MONO
     * TTF_HINTING_NONE
     * Hinting type is how the font is programmed to map onto the pixels on a screen
     * Note: the method flushes the internal cache of glyphs in the font, even if there is no change in hinting
     *       It may be useful to first check the font's hinting type
     */
    @property void hinting(int hinting) {
        TTF_SetFontHinting(this.font, hinting);
    }

    /**
     * Gets the font's hinting type
     * Type is returned as a value matching one of the following:
     * TTF_HINTING_NORMAL
     * TTF_HINTING_LIGHT
     * TTF_HINTING_MONO
     * TTF_HINTING_NONE
     * Type defaults to TTF_HINTING_NORMAL if no type has been set
     * Hinting type is how the font is programmed to map onto the pixels on a screen
     */
    @property int hinting() {
        return TTF_GetFontHinting(this.font);
    }

    /**
     * Sets the font's kerning setting
     * Default for newly created fonts is true
     * Kerning setting determines whether the spacing between individual characters is adjusted for a more pleasing result
     */
    @property void kerning(bool shouldKern) {
        TTF_SetFontKerning(this.font, shouldKern ? 1 : 0);
    }

    /**
     * Gets the font's kerning setting 
     * Default for a newly created fonts is true
     * Kerning setting determines whether the spacing between individual characters is adjusted for a more pleasing result
     */
    @property bool kerning() {
        return TTF_GetFontKerning(this.font) != 0;
    }

    /** 
     * Gets the maximum pixel height of all glyphs in this font
     * Useful for multiline printing
     */
    @property int height() {
        return TTF_FontHeight(this.font);
    }

    /**
     * Gets the maximum pixel ascent of all glyphs in this font
     * Ascent is the distance from the top of the glyph to the baseline
     */
    @property int ascent() {
        return TTF_FontAscent(this.font);
    }

    /**
     * Gets the maximum pixel descent of all glyphs in this font
     * Descent is the distance from the bottom of the glyph to the baseline
     */
    @property int descent() {
        return TTF_FontDescent(this.font);
    }

    /**
     * Gets the recommended pixel height of a line of text in this font
     * This represents the distance from the baseline to the top of the line
     * Line skip should be larger than height in most cases
     */
    @property int lineSkip() {
        return TTF_FontLineSkip(this.font);
    }

    /**
     * Gets the number of faces in this font
     * Faces are sub-fonts that vary slightly from the main font
     */
    @property long faces() {
        return TTF_FontFaces(this.font);
    }

    /**
     * Checks if the current font face of this font is fixed-width
     * Fixed-width fonts are monospace - each character is the same length
     * The pixel length of a string of fixed-width characters is the width of the characters times the amount of characters
     */
    @property bool isFixedWidth() {
        return TTF_FontFaceIsFixedWidth(this.font) > 0;
    }

    /**
     * Gets the font face family name (Times, Courier, etc.)
     * Returns null if not available
     */
    @property string familyName() {
        return TTF_FontFaceFamilyName(this.font).to!string;
    }

    /**
     * Gets the font face style name (Sans, Serif, etc.)
     * Returns null if not available
     */
    @property string styleName() {
        return TTF_FontFaceStyleName(this.font).to!string;
    }

    /**
     * Constructs a font from a font file
     */
    this(string file, int psize, int index = 0) {
        loadLibTTF();
        this.font = ensureSafe(TTF_OpenFontIndex(file.toStringz, psize, index));
    }

    /**
     * Constructs a font from an already existing TTF_Font
     */
    this(TTF_Font* alreadyExisting) {
        this.font = alreadyExisting;
    }

    /**
     * Ensures that SDL_TTF can dispose of this font
     */
    ~this() {
        TTF_CloseFont(this.font);
    }

    /**
     * Checks if the font supports the given glyph
     */
    bool isProvided(char glyph) {
        return TTF_GlyphIsProvided(this.font, glyph) != 0;
    }

    /**
     * Gets the minimum offset of the glyph
     * Returns the bottom left corner of the rectangle in which the glyph is inscribed in Cartesian coordinates
     */
    iVector minimumOffset(char glyph) {
        iVector offset = new iVector(0, 0);
        TTF_GlyphMetrics(this.font, glyph, &offset.x, &offset.y, null, null, null);
        return offset;
    }

    /**
     * Gets the maximum offset of the glyph
     * Returns the top right corner of the rectangle in which the glyph is inscribed in Cartesian coordinates
     */
    iVector maximumOffset(char glyph) {
        iVector offset = new iVector(0, 0);
        TTF_GlyphMetrics(this.font, glyph, null, null, &offset.x, &offset.y, null);
        return offset;
    }

    /**
     * Gets a rectangle describing the offset of the given glyph
     */
    iRectangle offset(char glyph) {
        iVector minOffset = this.minimumOffset(glyph);
        iVector maxOffset = this.maximumOffset(glyph);
        return new iRectangle(minOffset.x, maxOffset.y,
                maxOffset.x - minOffset.x, maxOffset.y - minOffset.y);
    }

    /**
     * Gets the advance offset of the glyph
     * The advance offset is the distance the pen must be shifted after drawing a glyph
     * Controls spacing between glyphs on an individual basis
     */
    int advanceOffset(char glyph) {
        int offset;
        TTF_GlyphMetrics(this.font, glyph, null, null, null, null, &offset);
        return offset;
    }

    /**
     * Renders the text on an 8-bit palettized surface with the given color
     * Background is transparent
     * Text is less smooth than other render options
     * This is the fastest rendering speed, and color can be changed without having to render again 
     */
    Surface renderTextSolid(string text, Color color, Encoding T = Encoding.UTF8) {
        switch (T) {
        case Encoding.LATIN1:
            return new Surface(TTF_RenderText_Solid(this.font,
                    text.toStringz, *color.handle));
        case Encoding.UTF8:
            return new Surface(TTF_RenderUTF8_Solid(this.font,
                    text.toStringz, *color.handle));
        case Encoding.UNICODE:
            return new Surface(TTF_RenderUNICODE_Solid(this.font,
                    (text.dup.map!(a => a.to!ushort).array ~ '\0').ptr, *color.handle));
        default:
            throw new Exception("No encoding given");
        }
    }

    /**
     * Renders the text with a given color on an 8-bit palettized surface with a given background color
     * Text is smooth but renders slowly
     * Surface blits as fast as the Solid render method once it is made
     */
    Surface renderTextShaded(string text, Color foreground, Color background,
            Encoding T = Encoding.UTF8) {
        switch (T) {
        case Encoding.LATIN1:
            return new Surface(TTF_RenderText_Shaded(this.font,
                    text.toStringz, *foreground.handle, *background.handle));
        case Encoding.UTF8:
            return new Surface(TTF_RenderUTF8_Shaded(this.font,
                    text.toStringz, *foreground.handle, *background.handle));
        case Encoding.UNICODE:
            return new Surface(TTF_RenderUNICODE_Shaded(this.font,
                    (text.dup.map!(a => a.to!ushort).array ~ '\0').ptr,
                    *foreground.handle, *background.handle));
        default:
            throw new Exception("No encoding given");
        }
    }

    /**
     * Renders the text in high quality on a 32-bit ARGB surface, using alpha blending to dither the font with the given color
     * The surface has alpha transparency
     * Renders about as slowly as the Shaded render method, but blits more slowly than Solid and Shaded
     */
    Surface renderTextBlended(string text, Color color, Encoding T = Encoding.UTF8) {
        switch (T) {
        case Encoding.LATIN1:
            return new Surface(TTF_RenderText_Blended(this.font,
                    text.toStringz, *color.handle));
        case Encoding.UTF8:
            return new Surface(TTF_RenderUTF8_Blended(this.font,
                    text.toStringz, *color.handle));
        case Encoding.UNICODE:
            return new Surface(TTF_RenderUNICODE_Blended(this.font,
                    (text.dup.map!(a => a.to!ushort).array ~ '\0').ptr, *color.handle));
        default:
            throw new Exception("No encoding given");
        }
    }

    /**
     * Renders a glyph quickly 
     * See renderTextSolid
     */
    Surface renderGlyphSolid(char glyph, Color color) {
        return new Surface(TTF_RenderGlyph_Solid(this.font, glyph, *color.handle));
    }

    /**
     * Renders a glyph slowly but smoothly
     * See renderTextShaded
     */
    Surface renderGlyphShaded(char glyph, Color foreground, Color background) {
        return new Surface(TTF_RenderGlyph_Shaded(this.font, glyph,
                *foreground.handle, *background.handle));
    }

    /**
     * Renders a glyph very slowly but with very high quality
     * See renderTextBlended
     */
    Surface renderGlyphBlended(char glyph, Color color) {
        return new Surface(TTF_RenderGlyph_Blended(this.font, glyph, *color.handle));
    }

}
