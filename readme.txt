Sumo mod by MisterE for use with arena_lib (minigame_lib) You should be familiar with how to set up arena_lib arenas.

Code snippets from https://gitlab.com/zughy-friends-minetest/arena_lib/-/blob/master/DOCS.md and from Zughy's minigames


to set up an arena, create a confined space that floats in the air, with lava or other damage blocks beneath. Set the spawners on the platform. You can use mesecons to make the board more interesting.

In this game, each player gets a tool that pushes other players... the goal is to knowck all other players off and be the last one standing. Each player gets 3 lives


Basic setup:

1) type /sumo create <arena_name>
2) type /sumo edit <arena_name>
3) use the editor to place a minigame sign, assign it to your minigame.
4) while in the editor, move to where your arena will be.
5) Make your arena. There should be some type of platform, with a lava pool underneath to kill players that fall off.
6) using the editor tools, mark player spawner locations. Protect the arena.
7) exit the editor mode
8) type /minigamesettings sumo 
9) change the hub spawnpoint to be next to the signs.










