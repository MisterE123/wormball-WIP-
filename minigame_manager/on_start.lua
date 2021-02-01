
-- counting the initial number of players in the game has been moved to an on_start function because the highscore info 
-- returned nil in a crash report. Perhaps not all players are accounted for in on_load. This ensures correct census info.
arena_lib.on_start('wormball', function(arena)
    local c = 0
    for pl_name, stats in pairs(arena.players) do
        c =c +1
    end
    arena.num_players = c

    -- set players' attachment entities

    for pl_name, stats in pairs(arena.players) do
        local player = minetest.get_player_by_name(pl_name)
        local pos = player:get_pos()
        local att = minetest.add_entity(pos, 'wormball:player_att')
        player:set_attach(att, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
        arena.players[pl_name].attached = true --indicates that the globalstep may take control; the player is supposed to be attached
    end


end)