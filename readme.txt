Wormball mod by MisterE for use with arena_lib (minigame_lib) You should be familiar with how to set up arena_lib arenas.

Code snippets from https://gitlab.com/zughy-friends-minetest/arena_lib/-/blob/master/DOCS.md and from Zughy's minigames
all assets cc0. Models by MisterE, textures by MisterE, and sounds CC0 from opengameart and/or freesound.org
Backgroundmusic :
wormball_bgm : Gamer_73 my-arcade   https://freesound.org/people/Gamer73/sounds/455016/


to set up an arena, create a completely enclosed arena out of any nodes you wish except those provided by this mod. 
You should place lights in the walls, or have glass to allow light in. In this version, you can have any shape arena you like. 
You may decorate the walls how you wish. Keep in mind that very large arenas may cause server lag during loading, and they are in general not fun to play in anyways.
Make the arena,

THEN note 2 position that bound your arena.... The game will place powerups and erase game peices within these locations.
enter these locations in the editor settings (described below)

Basic setup:

1) type /wormball create <arena_name>
2) type /wormball edit <arena_name>
3) use the editor to place a minigame sign, assign it to your minigame.
4) while in the editor, move to where your arena will be.
5) Make your arena. It should be a completely enclosed area, but can be any shape.
6) using the editor tools, mark player spawner locations. Protect the arena.
7) note to locations of 2 positions that completely bound the arena. From the minigame editor, go to settings > arena_settings.
8) type in the locations of the 2 opposite corners. Click on area_to_clear_after_game_pos1 and enter the correct values. then do the same with pos2. 


CAUTION: in the arena_settings, Y COMES FIRST! In the regular coordinate system, X COMES FIRST! Type the CORRECT values in... if you get it wrong, you may freeze your world and cause damage to it. 
BE CAREFUL TO GET THE CORRECT VALUES!!!!! also, if you get them wrong, the game will not work... the game tries to clear that when it loads, if you get it wrong, then it will clear the wrong area.

If you wish, you may change the other settings (except high_scores)

the formula used to determine whether to start erasing powerup dots is: 
if # dots in existence > min_food_factor * #players + min_food then
--have a 1/2 chance to erase a dot
end


9) exit the editor mode
10) type /minigamesettings wormball
11) change the hub spawnpoint to be next to the signs.


background music is available: it is in the sounds folder, and titled: wormball_bgm












