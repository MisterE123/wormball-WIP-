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
        groups = {cracky = 3,},
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
        groups = {cracky = 3,},
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
        groups = {cracky = 3,},
        sounds = default.node_sound_glass_defaults()
    })





end


minetest.register_node("wormball:straight_", {
    description = "wormball node straight",
    drawtype = "mesh",
    mesh = 'wormball_straight.b3d',
    tiles = {"wormball_straight.png", "wormball_end.png"},
    paramtype2 = "facedir",
    place_param2 = 4,
    paramtype = "light",
    backface_culling = true,
    sunlight_propagates = true, -- Sunlight can shine through block
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults()
})



--minetest.set_node(pos, {name = "nodename", param2 = N}) ,0 = z orient, 1= x orient, 4 = vertical y orient


minetest.register_node("wormball:corner_", {
    description = "wormball node corner",
    drawtype = "mesh",
    mesh = 'wormball_corner.b3d',
    tiles = {"wormball_straight.png", "wormball_end.png","wormball_corner_side.png","wormball_corner_top.png"},
    paramtype2 = "facedir",
    place_param2 = 16, 
    --0: -y -> -z,
    --1: -y -> -x,
    --2: -y -> +z,
    --3: -y -> +x,
    --4: +y -> -z,
    --5: -z -> -x,
    --6: -y -> -z,
    --7: +x -> -z,
    --8: -y -> +z,
    --9: -x -> +z,
    --10:+y -> +z,
    --11:+z -> +x,
    --12:-z -> -x,
    --13:+y -> -x,
    --14:-x, ->+z,
    --21:+y -> +x
    paramtype = "light",
    backface_culling = true,
    sunlight_propagates = true, -- Sunlight can shine through block
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
    sounds = default.node_sound_glass_defaults()
})


minetest.register_entity('wormball:player_att',{
    initial_properties = {
        physical = false,
        pointable = false,
        visual = "sprite",
        textures = {'wormball_alpha.png'},
        use_texture_alpha = true,
        is_visible = false,
    },
    _timer = 1,

    on_step = function(self, dtime, moveresult)
        -- self._timer = self._timer + dtime
        -- if self._timer < 6 and not(self.object:get_attach()) then
        --     self.object:remove()
        -- end
        return
        
        
    end,
 
})