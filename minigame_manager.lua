
--all files are in the minigame_manager folder

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/on_load.lua")

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/on_start.lua")

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/on_time_tick.lua")

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/globalstep.lua")

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/on_eliminate.lua")

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/on_timeout.lua")

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/on_disconnect.lua")

dofile(minetest.get_modpath("wormball") .. "/minigame_manager/on_celebration.lua")







