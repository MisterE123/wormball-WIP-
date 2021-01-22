Wormball mod by MisterE for use with arena_lib (minigame_lib) You should be familiar with how to set up arena_lib arenas.

Code snippets from https://gitlab.com/zughy-friends-minetest/arena_lib/-/blob/master/DOCS.md and from Zughy's minigames


to set up an arena, create a completely enclosed rectangular prism out of any nodes you wish except default:apple or any nodes provided by this mod. 
You should place lights in the walls, or have glass to allow light in. In this version, it is important that the playing area be a regular rectangluar area of nothing but air. 
You may decorate the walls how you wish. Keep in mind that very large arenas may cause server lag during loading, and they are in general not fun to play in anyways.
keep arenas below 30X30 at the max (max players is 10), and around 5x5x5 for singleplayer (min players is 1). Make the arena,

THEN note 2 opposite inside corners.... The game needs this to know what to erase before the match. type those points in to the arena properties dialogue under settings in the arena editor.

Basic setup:

1) type /wormball create <arena_name>
2) type /wormball edit <arena_name>
3) use the editor to place a minigame sign, assign it to your minigame.
4) while in the editor, move to where your arena will be.
5) Make your arena. It should be a perfect enclosed rectangular prism.
6) using the editor tools, mark player spawner locations. Protect the arena.
7) note to locations of 2 opposite inside corners. From the minigame editor, go to settings > arena_settings.
8) type in the locations of the 2 opposite corners. Click on area_to_clear_after_game_pos1 and enter the correct values. then do the same with pos2. 

CAUTION: in the arena_settings, Y COMES FIRST! In the regular coordinate system, X COMES FIRST! Type the CORRECT values in... if you get it wrong, you may freeze your world and cause damage to it. 
BE CAREFUL TO GET THE CORRECT VALUES!!!!! also, if you get them wrong, the game will not work... the game tries to clear that when it loads, if you get it wrong, then it will clear the wrong area.

9) exit the editor mode
10) type /minigamesettings wormball
11) change the hub spawnpoint to be next to the signs.










