module d2d.sdl2.Sound;

import std.algorithm;
import std.conv;
import std.string;
import std.traits;
import d2d.sdl2;

/**
 * The two types of sounds there are
 * Chunks are for sound effects and for shorter sounds
 * Musics are for longer sounds such as background music
 * Multiple chunks can play at once, but only one music can be playing at a time
 */
enum SoundType {
    Chunk,
    Music
}

/**
 * A sound is, as its name suggests, something that can be played and make a noise
 * Sounds are templated and can either be chunks or musics
 * A chunk sound is a short sound that is usually a sound effect or something quick; many chunks can play at once
 * A chunk will only play once
 * A music is something that usually plays for longer and is usually something like background music; only one sound can play at once
 * A music will loop infinitely until destroyed
 * This sound is a primitive port from SDL and doesn't allow for much control
 * There is no constructor for a sound from an already existing Mix_Chunk or Mix_Music because it may have unintended behaviour
 */
class Sound(SoundType T) {

    mixin("private Mix_" ~ T.to!string ~ "* sound;"); ///The actual sample from SDL

    /**
     * Returns the raw SDL data of this object
     */
    mixin("@property Mix_" ~ T.to!string ~ "* handle(){
        return this.sound;
    }");

    /**
     * Makes the sound given the string of the path of the sound
     * If this is a music sound, the music will loop; otherwise if this is a chunk, the chunk will play once
     */
    this(string soundPath) {
        loadLibMixer();
        static if (T == SoundType.Chunk) {
            this.sound = ensureSafe(Mix_LoadWAV(soundPath.toStringz));
            if (Mix_PlayChannel(-1, this.sound, 1) == -1) {
                ensureSafe(-1);
            }
        }
        else {
            this.sound = ensureSafe(Mix_LoadMUS(soundPath.toStringz));
            ensureSafe(Mix_PlayMusic(this.sound, -1));
        }
    }

    /**
     * Ensures that SDL can properly dispose of the chunk or music
     */
    mixin("~this(){
        Mix_Free" ~ T.to!string ~ "(this.sound);
    }");
}

/** 
 * Pauses all sounds of a type
 * There is no implementation to pause certain sounds selectively
 * Only the music is individually controllable
 * For chunks, chunks are collectively paused and unpaused
 */
void pause(SoundType T)() {
    static if(T == SoundType.Chunk) {
        ensureSafe(Mix_Pause(-1));
    }
    else {
        ensureSafe(Mix_PauseMusic());
    }
}

/** 
 * Resumes all sounds of a type
 * There is no implementation to resume certain sounds selectively
 * Only the music is individually controllable
 * For chunks, chunks are collectively paused and unpaused
 */
void resume(SoundType T)() {
    static if(T == SoundType.Chunk) {
        ensureSafe(Mix_Resume(-1));
    }
    else {
        ensureSafe(Mix_ResumeMusic());
    }
}

private int _chunkVolume = MIX_MAX_VOLUME;
private int _musicVolume = MIX_MAX_VOLUME;

/**
 * Sets the volume that all chunks will play at
 * Chunks are all at the same volume; there is no implementation to control the volume of an individual chunk
 */
@property void chunkVolume(int volume) {
    ensureSafe(Mix_Volume(-1, volume));
    _chunkVolume = volume;
}

/**
 * Gets the volume that all chunks will play at
 * Chunks are all at the same volume; there is no implementation to control the volume of an individual chunk
 */
@property int chunkVolume() {
    return _chunkVolume;
}

/**
 * Sets the volume that the music will play at
 */
@property void musicVolume(int volume) {
    ensureSafe(Mix_VolumeMusic(volume));
    _musicVolume = volume;
}

/** 
 * Gets the volume that the music will play at
 */
@property int musicVolume() {
    return _musicVolume;
}
