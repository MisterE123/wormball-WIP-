arena_lib.on_celebration('wormball', function(arena, winner_name)

    --reset player textures back to the texture they were... (wormball sets player textures to clear)

    for pl_name,stats in pairs(arena.players) do
        wormball.detach(pl_name)
    end

    

    --for now, arena_lib only supports single winners... change this when it supports multiple winners

    if type(winner_name) == 'string' then

        --Highscores are stored per number of players...
        
        --in a crash report, highscore was nil... WHY!? #BUG
        --crash (hopefully) prevented with nil check... place debug code here
        --note: crash occured when arena edit mode was entered while arena had crashed due to another bug, and the arena was still active (in_celebration)
        --note2: this will also prevent crashes due to arena editors messing with the highscores table.
        
        local highscore = arena.highscores[arena.num_players]
        if not highscore then  --nil check
            arena.highscores[arena.num_players] = {'pl_name_placeholder',0}
            highscore = {'pl_name_placeholder',0}
        end

        --old highscore info if existing
        local high_name = highscore[1] or '' 
        local high_num = highscore[2] or 0

        --current winner pts
        local winner_pts = arena.players[winner_name].score

        --HUD info sent to players
        arena_lib.HUD_send_msg_all("title", arena, winner_name..' won with '..winner_pts.. ' pts!', 9,'sumo_win',0xAEAE00)
        arena_lib.HUD_send_msg_all("hotbar", arena, 'Highscore: '..high_name.. ' '..high_num, 9,nil,0x0000FF)

        --if highscore was broken, 2 sec later, another HUD info abt that...
        if high_num < winner_pts then
            --set highscore info
            arena.highscores[arena.num_players] = {winner_name,winner_pts} --could this have cause the bug?
            minetest.after(2,function(arena,winner_name,winner_pts)
                arena_lib.HUD_send_msg_all("title", arena, 'NEW HIGH SCORE '.. arena.num_players ..' PLAYER!', 7,'sumo_win',0xAEAE00)
                arena_lib.HUD_send_msg_all("hotbar", arena, 'Highscore: '..winner_name.. ' '..winner_pts, 7,nil,0x0000FF)
            end,arena,winner_name,winner_pts)
        end

    end

end)


