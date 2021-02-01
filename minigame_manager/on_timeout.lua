--as soon as arena_lib supports multiple winners, make this more fair.
arena_lib.on_timeout('wormball', function(arena)
    local winner = {0,''}
    for pl_name, stats in pairs(arena.players) do
        if arena.players[pl_name].score > winner[1] then
            winner[1] = arena.players[pl_name].score
            winner[2] = pl_name
        end
    end

    
    arena_lib.load_celebration('wormball', arena, winner[2])
end)

