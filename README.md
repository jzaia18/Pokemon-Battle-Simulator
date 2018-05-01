# Pokemon Battle Simulator
A basic pokemon battle simulator
by Jake Zaia & Marie-Michelle Ivantechenko

## What is it
This is a pokemon battle simulator. It includes twelve different pokemon along with twenty seven different moves. Graphically, it has twenty four different sprites, three different backgrounds, over thirty different move and effect graphics, and over 50 custom text boxes. This version fully accounts for the correct stats, type effectiveness, physical special split, critical hits, volatile and non-volatile status conditions of the real pokemon games (as of 2016).

## How it Works
(This was written assuming one has basic knowledge of NetLogo)

The pokemon sprites that are appearing are drawings on the world called by the "import-drawing" function, and do nothing but look great graphically. The code uses turtles to store the variables for the moves and pokemon themselves. Each pokemon turtle has all of its corresponding stats as variables and its team alignment as its breed. Moves are hatched from the inital turtle and have all of the corresponding move stats as well as the pokemon they belong to AND the stats of the pokemon they belong to.
When running turns, it uses ask turtles to break up the order of operations and it consults a lot of lists (see list section of code) to get the information that it needs. Then based on that information, it runs the damage calculations and/or consults the list of status effects, and applies effects accordingly (graphic effects are run during this process). After that, it checks all of the global variables, tells the pokemon not to skip their next turn, and checks for fainting. Then, it increases the turn counter by one and runs the process again, and repeats this unti at least one pokemon faints, in which case everything stops, and a victory/defeat/tie message is displayed.

## How To Use it
Install NetLogo and open PokemonBattleSimulator.nlogo

Use the chooser to pick your pokemon. Use setup or reset to clear the field. Use run to run the game. Use the directional buttons and the use button to pick moves and adjust the pointer. (WASD and F can be used instead if preffered)

Note: Using the run function without using setup or reset once first will cause the code to break.


## Credits & References
* Marie-Michelle Ivantechenko & Jake Zaia
* Ms. Genkina for being a great CS teacher
* Nintendo's graphic design team for the sprites
* The developers of GIMP for creating such a useful program for free!
* Pokemon Showdown (http://www.play.pokemonshowdown.com) for being a major inspiration
* Edmond Wong for betatesting, debugging help, and overall support
* Piotr Milewski and Nick Pustilnik for being a worthy competition and great sports!
* Shoutout to all the classmates for the support and testing!
