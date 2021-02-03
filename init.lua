wormball = {}
dofile(minetest.get_modpath("wormball") .. "/globals.lua")

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
        speed = 1,
        jump = 1,
        sneak = false,
        gravity = 1,
    	},
      show_nametags = false,
      hotbar = {
        slots = 1,
        
      },
      celebration_time =10,
      disabled_damage_types = {"punch","fall"},
      properties = {
        area_to_clear_after_game_pos_1 = {x = 0, y = 0, z = 0},
        area_to_clear_after_game_pos_2 = {x = 0, y = 0, z = 0},
        min_food_factor = 2,
        min_food = 20,
        highscores = {
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},
          {'pl_name_placeholder',0},

        },
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
        attached = false,
      },
  })


if not minetest.get_modpath("lib_chatcmdbuilder") then
  dofile(minetest.get_modpath("wormball") .. "/chatcmdbuilder.lua")
end

dofile(minetest.get_modpath("wormball") .. "/commands.lua")
--nodes includes the attachment entity, also there are creative decorative worm body parts for decorating minigame hubs
dofile(minetest.get_modpath("wormball") .. "/nodes.lua")
dofile(minetest.get_modpath("wormball") .. "/privs.lua")
--minigame_manager simply runs all the files in the folder minigame_manager
dofile(minetest.get_modpath("wormball") .. "/minigame_manager.lua")


