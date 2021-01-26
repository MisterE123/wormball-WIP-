--todo: make it only delete wormball nodes in clear area, so unusuall shape arenas are possible.
--bgm
--colorize chat messages
--timer hud
--highscores

wormball.player_texture_save = {}

wormball.straight = {pxpx = 1,pzpz=0,pypy=4,
                    nxnx = 1,nznz=0,nyny=4,
                    nxpx = 1,nzpz=0,nypy=4,
                    pxnx = 1,pznz=0,pyny=4, } --format: axis
--format: sign,axis to sign,axis
wormball.corner = { --from, to
                  nynx=13,pynx=15,pznx=12,
                  nypz=10,pypz=2,pzpx=7,
                  nypx=21,pypx=17,nzpx=11,
                  nynz=20,pynz=0 ,nznx=9,

                  nxny=17,nxpy=19,nxpz=18,
                  pzny=0,pzpy=20,pxpz=9,
                  pxny=15,pxpy=13,pxnz=12,
                  nzny=2,nzpy=10 ,nxnz=7,
                  }
--format: dir pitch(h,u,d)for horiz, up or down ; dir facing
wormball.head = { 
                hpz=0,hpx=1,hnz=2,hnx=3,
                dpz=4,dpx=13,dnz=10,dnx=19,
                upz=8,upx=17,unz=6,unx=15,}



--when I do a place_node, I place the head in the facing dir and the pitch, and I update where the head (last )
function wormball.place_node(nodes,dir,old_dir,look_dir,color) --dir should be:{x=1[-1],y=1[-1],z=1[-1]} 
    --lookdir should be: 'px','nx','pz',or 'nz'
    if not look_dir then look_dir = 'py' end
    local dircode =''
    local old_dircode=''
    local type = 'straight' --type will be: straight, corner

    local axis = ''
    local old_axis = ''


    --dircode should ALWAYS be set, unless for some reason dir = {0,0,0}, which it shouldnt. Check this
    if dir.x ~= 0 then
        axis = 'x'
        if dir.x > 0 then
            dircode = 'px'
        else
            dircode = 'nx'
        end
    elseif dir.y ~= 0 then
        axis = 'y'
        if dir.y >0 then
            dircode = 'py'
        else
            dircode = 'ny'
        end
    elseif dir.z ~= 0 then
        axis = 'z'
        if dir.z > 0 then
            dircode = 'pz'
        else
            dircode = 'nz'
        end
    end
    if old_dir then
        if old_dir.x ~= 0 then
            old_axis = 'x'
            if old_dir.x > 0 then
                old_dircode = 'px'
            else
                old_dircode = 'nx'
            end
        elseif old_dir.y ~= 0 then
            old_axis = 'y'
            if old_dir.y > 0 then
                old_dircode = 'py'
            else
                old_dircode = 'ny'
            end
        elseif old_dir.z ~= 0 then
            old_axis = 'z'
            if old_dir.z > 0 then
                old_dircode = 'pz'
            else
                old_dircode = 'nz'
            end
        end

        if axis == old_axis then 
            type = 'straight'
        else
            type = 'corner'
        end
    

        local full_dircode = old_dircode..dircode --from dir..to dir

        if type == 'straight' and #nodes > 1 then
            minetest.set_node(nodes[2], {name="wormball:straight_"..color, param2 = wormball.straight[full_dircode]})
        elseif type == 'corner' and #nodes > 1 then
            minetest.set_node(nodes[2], {name="wormball:corner_"..color, param2 = wormball.corner[full_dircode]})
        end

    end

    local p_dir = 'h' --p, for pitch
    if dir.y == 1 then
        p_dir = 'u'
    elseif dir.y == -1 then
        p_dir = 'd'
    end

    local head_dir = p_dir..look_dir

    minetest.set_node(nodes[1], {name="wormball:head_"..color, param2 = wormball.head[head_dir]})


end



function wormball.get_look_dir(arena,player)

    local yaw = player:get_look_horizontal()
    local look_dir
    --get look_dir
    if yaw < (3.14*.25) or yaw > (3.14 *(7/4)) then -- if we are looking in the +z direction, 
        look_dir = 'pz'
    elseif yaw > (3.14*(1/4)) and yaw < (3.14 *(3/4)) then -- if we are looking in the -x direction
        look_dir = 'nx'
    elseif yaw > (3.14*(3/4)) and yaw < (3.14 *(5/4)) then -- if we are looking in the -z direction
        look_dir = 'nz'
    elseif yaw > (3.14*(5/4)) and yaw < (3.14 *(7/4)) then -- if we are looking in the +x direction
        look_dir = 'px'
    end
    return look_dir

end


local function send_message(arena,num_str)
    arena_lib.HUD_send_msg_all("title", arena, "Game Begins In "..num_str, 1,nil,0xFF0000)
    --arena_lib.HUD_send_msg_all(HUD_type, arena, msg, <duration>, <sound>, <color>)
end

arena_lib.on_load("wormball", function(arena)
    local c = 0
    for pl_name, stats in pairs(arena.players) do
        c =c +1
    end
    arena.num_players = c

    send_message(arena,'5')
    minetest.after(1, function(arena)
        send_message(arena,'4')
        minetest.after(1, function(arena)
            send_message(arena,'3')
            minetest.after(1, function(arena)
                send_message(arena,'2')
                minetest.after(1, function(arena)
                    send_message(arena,'1')
                    minetest.after(1, function(arena)
                        arena_lib.HUD_send_msg_all("title", arena, "GO!", 1,nil,0x00FF00)
                        minetest.after(1, function(arena)
                            arena_lib.HUD_send_msg_all("hotbar", arena, "Avoid Your Own Color, eat other dots!", 5,nil,0xFFAE00)
        
                        end, arena)
                    end, arena)

                end, arena)
                
            end, arena)
    
        end, arena)
    
    end, arena)

    --clear the board of gamepieces
    local pos1 = arena.area_to_clear_after_game_pos_1
    local pos2 = arena.area_to_clear_after_game_pos_2
    local x1 = pos1.x
    local x2 = pos2.x
    local y1 = pos1.y
    local y2 = pos2.y 
    local z1 = pos1.z 
    local z2 = pos2.z 
    if x1 > x2 then
        local temp = x2
        x2 = x1
        x1 = temp
    end
    if y1 > y2 then
        local temp = y2
        y2 = y1
        y1 = temp
    end
    if z1 > z2 then
        local temp = z2
        z2 = z1
        z1 = temp
    end

    for x = x1,x2 do
        for y = y1,y2 do
            for z = z1,z2 do
                --local node = minetest.get_node({x=x,y=y,z=z}).name
                
                minetest.set_node({x=x,y=y,z=z}, {name="air"})
                
            end
        end
    end





    local color_assign = {} -- a table of color names idxed by number
    local idx = 1
    for name,color in pairs(wormball.colors) do
        color_assign[idx] = name
        idx = idx + 1
    end
    idx = 1
    for pl_name, stats in pairs(arena.players) do
        local message = 'Controls: Use look direction to steer, or press jump or sneak to move.  Dont bump anything! Eat dots to grow and get points, but your own color will shrink you!'
        minetest.chat_send_player(pl_name,message)
        local player = minetest.get_player_by_name(pl_name)
        player:set_velocity({x=0,y=0,z=0})
        local pos = player:get_pos()
        local color = color_assign[idx]
        wormball.player_texture_save[pl_name] = player:get_properties().textures
        arena.players[pl_name].color = color
        player:set_properties({textures = {'wormball_alpha.png'}})
        arena.players[pl_name].nodes = {pos}
        local look_dir = wormball.get_look_dir(arena,player)
        wormball.place_node(arena.players[pl_name].nodes ,{x=0,y=1,z=0},{x=0,y=1,z=0},look_dir,color)

        local att = minetest.add_entity(pos, 'wormball:player_att')

        -- if att then minetest.chat_send_all('ent spawned!')
        -- else minetest.chat_send_all('ent not spawned!') end


        player:set_attach(att, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
        player_api.player_attached[pl_name] = true
        --player:set_eye_offset(eye_offset, {x=0, y=0, z=0})



        -- local att = minetest.add_entity(pos, 'wormball:player_att')
        -- --player_api.player_attached[pl_name] = true
        -- player:set_attach(att, "", {x=0,y=0,z=0}, {x=0,y=0,z=0}) 

        if idx > 1 then
            arena.mode = 'multiplayer'
        end
        idx = idx + 1
    end

end)




arena_lib.on_time_tick('wormball', function(arena)
    local c = 0x00FF00
    if arena.current_time < 60 then
        c = 0xFFFF00
    end
    if arena.current_time < 10 then
        c = 0xFF0000
    end

    if arena.current_time < arena.initial_time - 5 then
        arena_lib.HUD_send_msg_all('hotbar', arena, 'T - '..arena.current_time, 1,nil,c)
    end
    local p1 = arena.area_to_clear_after_game_pos_1
    local p2 = arena.area_to_clear_after_game_pos_2
    local x1 = p1.x 
    local x2 = p2.x
    local y1 = p1.y 
    local y2 = p2.y
    local z1 = p1.z 
    local z2 = p2.z
    if x2 < x1 then
        local temp = x2
        x2 = x1
        x1 = temp
    end
    if y2 < y1 then
        local temp = y2
        y2 = y1
        y1 = temp
    end
    if z2 < z1 then
        local temp = z2
        z2 = z1
        z1 = temp
    end
    local color_table = {}
    local i=1
    for color,code in pairs(wormball.colors) do
        color_table[i] = color
        i=i+1
    end

    local num_players = 0
    for pl_name,stats in pairs(arena.players) do
        num_players = num_players +1
    end

    local remove = false
    if #arena.dots and #arena.dots>num_players +5 then
        remove = true
    end

    for pl_name,stats in pairs(arena.players) do
        local rand_pos = {x = math.random(x1,x2),y = math.random(y1,y2), z=math.random(z1,z2)}
        local item = 'none'
        if math.random(1,3)== 1 then
            local color = color_table[math.random(1,#color_table)]
            item = "wormball:power_"..color
        end

        --put other  powerups here, with lower chances
        if item ~= 'none' then
            if minetest.get_node(rand_pos).name == 'air' then
                minetest.set_node(rand_pos, {name=item})
                table.insert(arena.dots,rand_pos)
            end
        end
        if remove then
            if math.random(1,2) == 1 then
                rem_pos = table.remove(arena.dots,math.random(4,#arena.dots))
                minetest.set_node(rem_pos, {name="air"})

            end
        end
    end


    return

end)








wormball.timer = 0

minetest.register_globalstep(function(dtime)
    --if wormball.timer then wormball.timer = 0 end

    wormball.timer = wormball.timer+dtime
    if wormball.timer < .4 then return
    end
    wormball.timer = 0
    

    for _,player in ipairs(minetest.get_connected_players()) do
        local pl_name = player:get_player_name()

        if arena_lib.is_player_in_arena(pl_name, "wormball") then
            local arena = arena_lib.get_arena_by_player(pl_name)
            if not(arena.in_queue == true) and not (arena.in_loading == true) and not(arena.in_celebration == true) and arena.enabled == true then 
                
                local stats = arena.players[pl_name]
                local remove_tail = true
                if stats.alive == true then
                    local old_dir = arena.players[pl_name].old_direction or {x=0,y=1,z=0} --grab the old_dir info before its updated
                    local player = minetest.get_player_by_name(pl_name)
                    local color = stats.color
                    local look_dir = ''
                    --+x is forward, +z is left
                    local control = player:get_player_control() --{jump=bool, right=bool, left=bool, LMB=bool, RMB=bool, sneak=bool, aux1=bool, down=bool, up=bool}
                    
                    local yaw = player:get_look_horizontal()

                    local look_dir = wormball.get_look_dir(arena,player)

                    if control.jump == true then 
                        arena.players[pl_name].direction = {x=0,y=1,z=0}
                    elseif control.sneak == true then
                        arena.players[pl_name].direction = {x=0,y=-1,z=0}
                    elseif look_dir == 'pz' then -- if we are looking in the +z direction, 
                        arena.players[pl_name].direction = {x=0,y=0,z=1}
                    elseif look_dir == 'nx' then -- if we are looking in the -x direction
                        arena.players[pl_name].direction = {x=-1,y=0,z=0}
                    elseif look_dir == 'nz' then -- if we are looking in the -z direction
                        arena.players[pl_name].direction = {x=0,y=0,z=-1}
                    elseif look_dir == 'px' then -- if we are looking in the +x direction
                        arena.players[pl_name].direction = {x=1,y=0,z=0}
                    end
                    --save the direction info for next round
                    arena.players[pl_name].old_direction = arena.players[pl_name].direction
                    --get look_dir
                    
                    
                    

                    local new_move = stats.direction

                    local head_pos = stats.nodes[1]
                

                    local new_pos = {x = head_pos.x + new_move.x, y = head_pos.y + new_move.y, z = head_pos.z + new_move.z}

                    local new_node = minetest.get_node(new_pos).name

                    if new_node == 'air' then
                        if arena.players[pl_name].move == true then
                            table.insert(arena.players[pl_name].nodes,1,new_pos)
                            --minetest.set_node(new_pos, {name="wormball:node_"..color})
                            wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)

                            --player:move_to(new_pos, true)
                            local att = player:get_attach()
                            if att then
                                att:move_to(new_pos, true)
                            else
                                --minetest.chat_send_all('not_attached!')
                            end
                        else
                            arena.players[pl_name].move = true
                        end

                    elseif new_node == "wormball:power_"..color then --oops, hit own color, remove 1 length
                        for _,dot in pairs(arena.dots) do
                            if dot == new_pos then
                                table.remove(arena.dots,_)
                            end
                        end
                        


                        if arena.players[pl_name].move == true then
                            table.insert(arena.players[pl_name].nodes,1,new_pos)
                            --minetest.set_node(new_pos, {name="wormball:node_"..color})
                            wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)
                            arena.players[pl_name].score = arena.players[pl_name].score - 1
                            --minetest.chat_send_player(pl_name,'YUCK! You Lost a point.')
                            --minetest.chat_send_all('bad!')
                            arena_lib.HUD_send_msg('broadcast', pl_name, 'YUCK! You Lost a point.', 2, 'wormball_yuck',0xFF0000)
                            
                            
                            local att = player:get_attach()
                            if att then
                                att:move_to(new_pos, true)
                            else
                                --minetest.chat_send_all('not_attached!')
                            end
                        else
                            arena.players[pl_name].move = true
                        end

                        
                        remove_tail = true
                        arena.players[pl_name].move = false

                    elseif string.find(new_node,'wormball:power_') then --we found a powerup!

                        for _,dot_pos in pairs(arena.dots) do
                            if dot_pos == new_pos then
                                table.remove(arena.dots,_)
                            end
                        end

                        if arena.players[pl_name].move == true then
                            remove_tail = false
                            table.insert(arena.players[pl_name].nodes,1,new_pos)
                            --minetest.set_node(new_pos, {name="wormball:node_"..color})
                            wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)
                            arena.players[pl_name].score = arena.players[pl_name].score + 1
                            --minetest.chat_send_player(pl_name,'You are now '..arena.players[pl_name].score..' long.')
                            arena_lib.HUD_send_msg('broadcast', pl_name, 'Yay! You are now '..arena.players[pl_name].score..' long.', 2, 'wormball_powerup',0x00FF11)
                            local att = player:get_attach()
                            if att then
                                att:move_to(new_pos, true)
                            else
                                --minetest.chat_send_all('not_attached!')
                            end
                        else
                            arena.players[pl_name].move = true
                        end


                    else --we have run into something
                        arena.players[pl_name].alive = false
                        minetest.sound_play('sumo_lose', {
                            to_player = pl_name,
                            gain = 2.0,
                        })
                        local n = 0
                        for name, stat in pairs(arena.players) do
                            n = n+1
                        end

                        if n == 1 then
                            minetest.chat_send_player(pl_name,'your score is '..arena.players[pl_name].score)
                            --disengage before removing player
                            if player then
                                player:set_properties({textures = wormball.player_texture_save[pl_name]})
                                local att = player:get_attach()
                                player:set_detach()
                                player_api.player_attached[pl_name] = false
                                if att then att:remove() end
                                minetest.sound_play(sound, {
                                    to_player = p_name,
                                    gain = 2.0,
                                })        
                            end
                            arena.players[pl_name].alive = false
                            minetest.after(1, function(pl_name) 
                                
                                arena_lib.remove_player_from_arena(pl_name, 1)
                            
                            end,pl_name)
                            
                            --return
                        end

                    end

                    --place an apple
                    


                end

                if remove_tail == true then
                    local len = #arena.players[pl_name].nodes
                    local tail_pos = arena.players[pl_name].nodes[len]
                    if tail_pos then 
                        minetest.set_node(tail_pos, {name="air"}) 
                        table.remove(arena.players[pl_name].nodes,len)
                    end
                end

                if #arena.players[pl_name].nodes == 0 then
                    minetest.chat_send_player(pl_name, 'Your score is '..arena.players[pl_name].score)
                    arena.players[pl_name].alive = false
                    local player = minetest.get_player_by_name(pl_name)
                    if player then
                        player:set_properties({textures = wormball.player_texture_save[pl_name]})
                        local att = player:get_attach()
                        player:set_detach()
                        player_api.player_attached[pl_name] = false
                        if att then att:remove() end
                        minetest.sound_play(sound, {
                            to_player = p_name,
                            gain = 2.0,
                        })        
                    end
                    arena.players[pl_name].alive = false
                    minetest.after(1, function(pl_name) 
                        
                        arena_lib.remove_player_from_arena(pl_name, 1)
                    
                    end,pl_name)
                end
            end
        end

    end
end)















arena_lib.on_eliminate('wormball', function(arena, p_name)
    
    
    --minetest.chat_send_all(dump(arena))

    local count = 0
    local sound = 'sumo_elim'
    local win_player = nil
    for p_name,data in pairs(arena.players) do
        count = count + 1
        win_player = p_name
    end
    if count == 1 then
        sound = 'sumo_win'
    end
    if arena.mode == 'multiplayer' and count == 1 then
        if win_player then
            win_player_obj = minetest.get_player_by_name(win_player)
            win_player_obj:set_properties({textures = wormball.player_texture_save[win_player]})
            minetest.after(1,function(arena,win_player)
                arena_lib.load_celebration('wormball', arena, win_player)
            end,arena,win_player)
            local att = win_player_obj:get_attach()
            win_player_obj:set_detach()
            player_api.player_attached[win_player] = false
            if att then att:remove() end
        end
    end


    local player = minetest.get_player_by_name(p_name) or nil
    -- if player then
    --     --minetest.chat_send_all('player_textures is: '..dump(arena.players[p_name].textures))
    --     player:set_properties({textures = wormball.player_texture_save[p_name]})
    --     local att = player:get_attach()
    --     player:set_detach()

    --     if att then att:remove() end
    -- end

    for p_name, stats in pairs(arena.players) do
        
        
        minetest.sound_play(sound, {
            to_player = p_name,
            gain = 2.0,
        })        
    end


end)

arena_lib.on_disconnect('wormball', function(arena, p_name)
    local player = minetest.get_player_by_name(p_name)
    if player then
        player:set_properties({textures = wormball.player_texture_save[p_name]})
        local att = player:get_attach()
        player_api.player_attached[p_name] = false
        player:set_detach()
        if att then att:remove() end
    end

end)



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

arena_lib.on_celebration('wormball', function(arena, winner_name)
    for pl_name,stats in pairs(arena.players) do
        local player = minetest.get_player_by_name(pl_name)
        if player then
            player:set_properties({textures = wormball.player_texture_save[pl_name]})
            local att = player:get_attach()
            player:set_detach()
            player_api.player_attached[pl_name] = false
            if att then att:remove() end
                  
        end
    end


    if type(winner_name) == 'string' then
        local highscore_tbl = {'highscore_1','highscore_2','highscore_3','highscore_4','highscore_5','highscore_6','highscore_7','highscore_8','highscore_9','highscore_10',}
        
        local highscore = arena.highscores[arena.num_players]


        local high_name = highscore[1]
        local high_num = highscore[2]
        local winner_pts = arena.players[winner_name].score
        arena_lib.HUD_send_msg_all("title", arena, winner_name..' won with '..winner_pts.. ' pts!', 9,'sumo_win',0xAEAE00)
        arena_lib.HUD_send_msg_all("hotbar", arena, 'Highscore: '..high_name.. ' '..high_num, 9,nil,0x0000FF)
        if high_num < winner_pts then
            arena.highscores[arena.num_players] = {winner_name,winner_pts}
            minetest.after(2,function(arena,winner_name,winner_pts)
                arena_lib.HUD_send_msg_all("title", arena, 'NEW HIGH SCORE '.. arena.num_players ..' PLAYER!', 7,'sumo_win',0xAEAE00)
                arena_lib.HUD_send_msg_all("hotbar", arena, 'Highscore: '..winner_name.. ' '..winner_pts, 7,nil,0x0000FF)
            end,arena,winner_name,winner_pts)
        end
            



        
    end
        


end)


