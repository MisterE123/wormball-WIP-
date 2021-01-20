for name,color in pairs(wormball.colors) do
    minetest.register_node("wormball:node_"..name, {
        description = "wormball node "..name,
        drawtype = "glasslike_framed",
        tiles = {"default_stone.png^[colorize:#"..color, "default_stone.png^[colorize:#"..color},
        inventory_image = minetest.inventorycube("default_stone.png^[colorize:#"..color),
        paramtype = "light",
        sunlight_propagates = true, -- Sunlight can shine through block
        groups = {cracky = 3, oddly_breakable_by_hand = 3},
        sounds = default.node_sound_glass_defaults()
    })
end
