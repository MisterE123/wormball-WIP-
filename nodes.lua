


--register minigame worm body parts

for name,color in pairs(wormball.colors) do

    
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


--register creative decorative worm bodyparts (pointable, rotatable, and breakable by hand, and in creative inv)




for name,color in pairs(wormball.colors) do

    minetest.register_node("wormball:creative_straight_"..name, {
        description = "wormball creative node straight "..name,
        drawtype = "mesh",
        mesh = 'wormball_straight.b3d',
        tiles = {"wormball_straight.png^[colorize:#"..color, "wormball_end.png^[colorize:#"..color},
        paramtype2 = "facedir",
        paramtype = "light",
        pointable = true,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {oddly_breakable_by_hand = 1,},
        sounds = default.node_sound_glass_defaults()
    })
        
    minetest.register_node("wormball:creative_corner_"..name, {
        description = "wormball creative node corner "..name,
        drawtype = "mesh",
        mesh = 'wormball_corner.b3d',
        tiles = {"wormball_straight.png^[colorize:#"..color, "wormball_end.png^[colorize:#"..color,"wormball_corner_side.png^[colorize:#"..color,"wormball_corner_top.png^[colorize:#"..color},
        paramtype2 = "facedir", 
        pointable = true,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {oddly_breakable_by_hand = 1,},
        sounds = default.node_sound_glass_defaults()
    })

    minetest.register_node("wormball:creative_head_"..name, {
        description = "wormball creative head "..name,
        drawtype = "mesh",
        mesh = 'wormball_head.b3d',
        tiles = {"wormball_head.png^[colorize:#"..color,"wormball_eye.png"},
        paramtype2 = "facedir", 
        pointable = true,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {oddly_breakable_by_hand = 1,},
        sounds = default.node_sound_glass_defaults()
    })

    

    minetest.register_node("wormball:creative_power_"..name, {
        description = "wormball creative power "..name,
        drawtype = "mesh",
        mesh = 'wormball_power.b3d',
        tiles = {"wormball_power.png^[colorize:#"..color},
        paramtype2 = "facedir",
        pointable = true,
        backface_culling = true,
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {oddly_breakable_by_hand = 1,},
        sounds = default.node_sound_glass_defaults()
    })





end

--register attachment entity

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
})




