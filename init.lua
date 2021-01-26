wormball = {}
--lookup tables
wormball.colors = {yellow = "fcba0388", 
                  orangered = "fc280388", 
                  darkred = "a1000088", 
                  lightgreen = "80ff0088", 
                  aqua = "00ff8488",
                  lightblue = "0084ff88",
                  darkblue = "0d00ff88",
                  purple = "8000ff88",
                  lightpurple = "ee00ff88",
                  pink = "ff006f88"}




  arena_lib.register_minigame("wormball", {
      prefix = "[Wormball] ",
      --hub_spawn_point = { x = 0, y = 20, z = 0 },
      show_minimap = false,
      time_mode = 'decremental',
      load_time = 5,
      min_players = 1,
      max_players = 10,
      join_while_in_progress = false,
      keep_inventory = false,
      in_game_physics = {
        speed = 2,
        jump = 3,
        sneak = false,
        gravity = 1,
    	},
      show_nametags = true,
      hotbar = {
        slots = 0,
        
      },
      celebration_time =10,
      disabled_damage_types = {"punch","fall"},
      properties = {
        area_to_clear_after_game_pos_1 = {x = 0, y = 0, z = 0},
        area_to_clear_after_game_pos_2 = {x = 0, y = 0, z = 0},
        highscore_1 = {'pl_name_placeholder',0},
        highscore_2 = {'pl_name_placeholder',0},
        highscore_3 = {'pl_name_placeholder',0},
        highscore_4 = {'pl_name_placeholder',0},
        highscore_5 = {'pl_name_placeholder',0},
        highscore_6 = {'pl_name_placeholder',0},
        highscore_7 = {'pl_name_placeholder',0},
        highscore_8 = {'pl_name_placeholder',0},
        highscore_9 = {'pl_name_placeholder',0},
        highscore_10 = {'pl_name_placeholder',0},

      },
      temp_properties = {
        mode = 'singleplayer',
        dots = {},
        num_players = 0,
      },
      initial_time = 300,

      player_properties = {
        alive = true,
        direction = {x=0,y=1,z=0},
        old_direction = {x=0,y=1,z=0},
        nodes = {},
        score = 1,
        color = "",
        apple = false,
        --textures= {},
        move = true,
      },
  })


if not minetest.get_modpath("lib_chatcmdbuilder") then
  dofile(minetest.get_modpath("wormball") .. "/chatcmdbuilder.lua")
end

dofile(minetest.get_modpath("wormball") .. "/commands.lua")
dofile(minetest.get_modpath("wormball") .. "/minigame_manager.lua")
dofile(minetest.get_modpath("wormball") .. "/nodes.lua")
dofile(minetest.get_modpath("wormball") .. "/privs.lua")

