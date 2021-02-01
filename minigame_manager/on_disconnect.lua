
--basic cleanup

arena_lib.on_disconnect('wormball', function(arena, p_name)
    local player = minetest.get_player_by_name(p_name)
    if player then
        player:set_properties({textures = wormball.player_texture_save[p_name]})
        local att = player:get_attach()
        player:set_detach()
        if att then att:remove() end
    end

end)