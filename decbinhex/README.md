# decbinhex

![preview](./.README/preview.png)

Just a basic 2d application to convert decimal/binary/hexadecimal numbers.

I used all newest stable stuff to make this. Godot 3.4, Nim 1.6.0, Godot-Nim 0.8.5* (note the stub.nimble usage of `requires "https://github.com/dsrw/godot-nim#f2af444"`, see https://github.com/pragmagic/godot-nim/pull/114). You also need to install tcc (Tiny C compiler) or go into `nim.cfg` and change the `--cc:tcc` option to use gcc or clang instead (tcc is much faster but I don't know about full capability for Godot... Clang isn't too bad for speed either). Otherwise, normal build process.

Also there's a tiny bit of code (on the hidden polygon) for direct movement (local movement, rotation, also global movement commented out). No point yet but it should be helpful info on its own for actual simple games (and my next goal).

Note that I'm a beginner with both Nim and Godot (this is part of my learning and hopefully will do more with Godot-Nim), feel free to give me advice (insomniac_lemon on Reddit), point out issues, or to simply fix any small technical mistakes/practices (can't say that I'll get it, but I'll look at the changes).
