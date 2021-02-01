

arena_lib.on_eliminate('wormball', function(arena, p_name)
    
    --play sound to remaining players
    for pl_name, stats in pairs(arena.players) do
        if pl_name ~= p_name then
            minetest.sound_play('sumo_elim', {
                to_player = pl_name,
                gain = 2.0,
            })
        else
            minetest.sound_play('sumo_lose', {
                to_player = p_name,
                gain = 2.0,
            })
        end

    end
    

    
end)
