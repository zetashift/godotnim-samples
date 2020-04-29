## Nimified 'Dodge the Creeps' and 'Game of Life'

For now only Dodge the Nim works fully on 1.0. This however should show you how a lot of things are done in godot-nim.

NOTE: If you get a NilAccessError on the method `onMobTimerTimeout` please load the Mob scene in the editor on the Main Node. 
So select the Main node and in your Inspector you should see 'mob' as one of the script variables, load the Mob scene located in the `scenes` folder.

Most likely this is a Godot/GDNative thing, and you could do this using only code and not using a script variable per se.

Make sure you have Godot(3.0+) and Nim(1.0+) and the [bindings](https://github.com/pragmagic/godot-nim) installed when you want to try these out. Run `nake build` in a samples directory to get started.
Code isn't pretty as I'm still learning and I wrote this to orientate myself around both projects.

Thanks to Skaruts for bringing the samples up to date for Nim 1.0

### TODO

Add the sound effects and particles to the Dodge the Creeps project.
FIX the nimway project to work on 1.0
