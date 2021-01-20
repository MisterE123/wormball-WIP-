wormball = {}
wormball.colors = {yellow = "fcba03", 
                  orangered = "fc2803", 
                  darkred = "a10000", 
                  lightgreen = "80ff00", 
                  aqua = "00ff84",
                  lightblue = "0084ff",
                  darkblue = "0d00ff",
                  purple = "8000ff",
                  lightpurple = "ee00ff",
                  pink = "ff006f"}


  arena_lib.register_minigame("wormball", {
      prefix = "[Wormball] ",
      --hub_spawn_point = { x = 0, y = 20, z = 0 },
      show_minimap = false,
      time_mode = 1,
      load_time = 5,
      min_players = 1,
      max_players = 10,
      join_while_in_progress = false,
      keep_inventory = false,
      in_game_physics = {
        speed = 0,
        jump = 0,
        sneak = false,
        gravity = 0,
    	},
      show_nametags = true,
      hotbar = {
        slots = 0,
        
      },

      disabled_damage_types = {"punch","fall"},
      properties = {
        area_to_clear_after_game_pos_1 = {x = 0, y = 0, z = 0},
        area_to_clear_after_game_pos_2 = {x = 0, y = 0, z = 0},
      },
      player_properties = {
        alive = true,
        direction = {x=0,y=1,z=0},
        nodes = {},
        score = 1,
        color = "",
        apple = false,
      },
  })


if not minetest.get_modpath("lib_chatcmdbuilder") then
  dofile(minetest.get_modpath("wormball") .. "/chatcmdbuilder.lua")
end

dofile(minetest.get_modpath("wormball") .. "/commands.lua")
dofile(minetest.get_modpath("wormball") .. "/minigame_manager.lua")
dofile(minetest.get_modpath("wormball") .. "/nodes.lua")
dofile(minetest.get_modpath("wormball") .. "/privs.lua")

