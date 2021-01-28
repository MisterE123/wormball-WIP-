for name,color in pairs(wormball.colors) do
    -- minetest.register_node("wormball:node_"..name, {
    --     description = "wormball node "..name,
    --     drawtype = "glasslike_framed",
    --     tiles = {"default_stone.png^[colorize:#"..color, "default_stone.png^[colorize:#"..color},
    --     inventory_image = minetest.inventorycube("default_stone.png^[colorize:#"..color),
    --     paramtype = "light",
    --     sunlight_propagates = true, -- Sunlight can shine through block
    --     groups = {cracky = 3, oddly_breakable_by_hand = 3},
    --     sounds = default.node_sound_glass_defaults()
    -- })
    
    minetest.register_node("wormball:straight_"..name, {
        description = "wormball node straight "..name,
        drawtype = "mesh",
        mesh = 'wormball_straight.b3d',
        tiles = {"wormball_straight.png^[colorize:#"..color, "wormball_end.png^[colorize:#"..color},
        paramtype2 = "facedir",
        place_param2 = 4,
        paramtype = "light",
        pointable = false,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })
        
    minetest.register_node("wormball:corner_"..name, {
        description = "wormball node corner "..name,
        drawtype = "mesh",
        mesh = 'wormball_corner.b3d',
        tiles = {"wormball_straight.png^[colorize:#"..color, "wormball_end.png^[colorize:#"..color,"wormball_corner_side.png^[colorize:#"..color,"wormball_corner_top.png^[colorize:#"..color},
        paramtype2 = "facedir",
        place_param2 = 16, 
        pointable = false,
        paramtype = "light",
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })

    minetest.register_node("wormball:head_"..name, {
        description = "wormball head "..name,
        drawtype = "mesh",
        mesh = 'wormball_head.b3d',
        tiles = {"wormball_head.png^[colorize:#"..color,"wormball_eye.png"},
        paramtype2 = "facedir",
        place_param2 = 16, 
        pointable = false,
        paramtype = "light",
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })

    

    minetest.register_node("wormball:power_"..name, {
        description = "wormball power "..name,
        drawtype = "mesh",
        mesh = 'wormball_power.b3d',
        tiles = {"wormball_power.png^[colorize:#"..color},
        paramtype2 = "facedir",
        paramtype = "light",
        pointable = false,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })





end







for name,color in pairs(wormball.colors) do

    minetest.register_node("wormball:creative_straight_"..name, {
        description = "wormball creative node straight "..name,
        drawtype = "mesh",
        mesh = 'wormball_straight.b3d',
        tiles = {"wormball_straight.png^[colorize:#"..color, "wormball_end.png^[colorize:#"..color},
        paramtype2 = "facedir",
        paramtype = "light",
        pointable = false,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })
        
    minetest.register_node("wormball:creative_corner_"..name, {
        description = "wormball creative node corner "..name,
        drawtype = "mesh",
        mesh = 'wormball_corner.b3d',
        tiles = {"wormball_straight.png^[colorize:#"..color, "wormball_end.png^[colorize:#"..color,"wormball_corner_side.png^[colorize:#"..color,"wormball_corner_top.png^[colorize:#"..color},
        paramtype2 = "facedir", 
        pointable = false,
        paramtype = "light",
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })

    minetest.register_node("wormball:creative_head_"..name, {
        description = "wormball creative head "..name,
        drawtype = "mesh",
        mesh = 'wormball_head.b3d',
        tiles = {"wormball_head.png^[colorize:#"..color,"wormball_eye.png"},
        paramtype2 = "facedir", 
        pointable = false,
        paramtype = "light",
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })

    

    minetest.register_node("wormball:creative_power_"..name, {
        description = "wormball creative power "..name,
        drawtype = "mesh",
        mesh = 'wormball_power.b3d',
        tiles = {"wormball_power.png^[colorize:#"..color},
        paramtype2 = "facedir",
        paramtype = "light",
        pointable = false,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {not_in_creative_inventory = 1,},
        sounds = default.node_sound_glass_defaults()
    })





end








-- minetest.register_node("wormball:power", {
--     description = "wormball node straight",
--     drawtype = "mesh",
--     mesh = 'wormball_power.b3d',
--     tiles = {"wormball_power.png^[colorize:#e0bb00bb"},
--     paramtype2 = "facedir",
--     paramtype = "light",
--     backface_culling = true,
--     sunlight_propagates = true, -- Sunlight can shine through block
--     groups = {cracky = 3, oddly_breakable_by_hand = 3},
--     sounds = default.node_sound_glass_defaults()
-- })





minetest.register_entity('wormball:player_att',{
    initial_properties = {
        physical = false,
        pointable = false,
        visual = "sprite",
        textures = {'wormball_alpha.png'},
        use_texture_alpha = true,
        is_visible = false,
    },
    _timer = 0,

    on_step = function(self, dtime, moveresult)
        self._timer = self._timer + dtime
        if self._timer >= 900 then
            self.object:remove()
        end

        return
        
        
    end,
<<<<<<< Updated upstream
=======
    -- on_attach_child = function(self, child)
    --     if child:is_player() then
    --         minetest.chat_send_all(child:get_player_name()..' was attached')
    --     end

    -- end,
    -- on_detach_child = function(self, child)
    --     if child:is_player() then
    --         minetest.chat_send_all(child:get_player_name()..' was detached')
    --     end

    -- end,
>>>>>>> Stashed changes
 
})




