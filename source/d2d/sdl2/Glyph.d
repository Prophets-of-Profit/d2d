module d2d.sdl2.Glyph;

import d2d.sdl2;

/**
 * A representation of a character in a font
 * Contains individual values representing its size in the font
 */
struct Glyph {

    private char glyph;
    private Font font;      ///The font that contains the glyph; whether or not the font supports the glyph is not strictly enforced

    /**
     * Gets the glyph as a character
     */
    @property char asCharacter() {
        return glyph;
    }

    /**
     * Gets the glyph as a UNICODE-encoded ushort character
     */
    @property ushort asUshort() {
        return cast(ushort)glyph;
    }

    /**
     * Checks if the glyph is supported by its font
     */
    @property isProvided() {
        return TTF_GlyphIsProvided(this.font.handle, this.asUshort);
    }

    /**
     * Gets the minimum offset of the glyph
     * Returns the bottom left corner of the rectangle in which the glyph is inscribed in Cartesian coordinates
     */
    @property iPoint minimumOffset() {
        iPoint offset = new iPoint(0, 0);
        TTF_GlyphMetrics(font.handle, this.asUshort, &offset.x, &offset.y, null, null, null);
        return offset;
    }

    /**
     * Gets the maximum offset of the glyph
     * Returns the top right corner of the rectangle in which the glyph is inscribed in Cartesian coordinates
     */
    @property iPoint maximumOffset() {
        iPoint offset = new iPoint(0, 0);
        TTF_GlyphMetrics(font.handle, this.asUshort, null, null, &offset.x, &offset.y, null);
        return offset;
    }

    /**
     * Gets the advance offset of the glyph
     * The advance offset is the distance the pen must be shifted after drawing a glyph
     * Controls spacing between glyphs on an individual basis
     */
    @property int advanceOffset() {
        int offset;
        TTF_GlyphMetrics(font.handle, this.asUshort, null, null, null, null, &offset);
        return offset;
    }

    /**
     * A Glyph constructor; takes in a character to represent and a font context
     */
    this(char ch, Font font) {
        this.glyph = ch;
        this.font = font;
    }

}