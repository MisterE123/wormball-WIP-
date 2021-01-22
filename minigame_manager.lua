
-- wormball.straight = {pxpx = 1,pzpz=0,pypy=4,
--                     nxnx = 1,nznz=0,nyny=4,
--                     nxpx = 1,nzpz=0,nypy=4,
--                     pxnx = 1,pznz=0,pyny=4, } --format: axis
-- --format: sign,axis to sign,axis
-- wormball.corner = { 
--                   nynx=1,pynx=13,pznx=9,
--                   nypz=2,pypz=10,pzpx=11,
--                   nypx=3,pypx=21,nzpx=7,
--                   nynz=0,pynz= 4,nznx=5,

--                   nxny=1,nxpy=13,nxpz=9,
--                   pzny=2,pzpy=10,pxpz=11,
--                   pxny=3,pxpy=21,pxnz=7,
--                   nzny=0,nzpy= 4,nxnz=5,
--                   }
-- --format: dir pitch(h,u,d)for horiz, up or down ; dir facing
-- wormball.head = { 
--                 hpz=0,hpx=1,hnz=2,hnx=3,
--                 dpz=4,dpx=13,dnz=10,dnx=19,
--                 upz=8,upx=17,unz=6,unx=15,}

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
     
        -- minetest.chat_send_all('dir = '..dump(dir))
        -- minetest.chat_send_all('old_dir = '..dump(old_dir))
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




arena_lib.on_load("wormball", function(arena)

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
        local message = 'Controls: Use look direction to steer, or press up or down.  Dont bump anything! Eat apples to grow and get points!'
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

        if att then minetest.chat_send_all('ent spawned!')
        else minetest.chat_send_all('ent not spawned!') end


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

    for pl_name,stats in pairs(arena.players) do
        local rand_pos = {x = math.random(x1,x2),y = math.random(y1,y2), z=math.random(z1,z2)}
        local item = 'none'
        if math.random(1,3)== 1 then
            item = 'default:apple'
        end
        --put other  powerups here, with lower chances
        if item ~= 'none' then
            minetest.set_node(rand_pos, {name=item})
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
                        table.insert(arena.players[pl_name].nodes,1,new_pos)
                        --minetest.set_node(new_pos, {name="wormball:node_"..color})
                        wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)

                        --player:move_to(new_pos, true)
                        local att = player:get_attach()
                        if att then
                            att:move_to(new_pos, true)
                        else
                            minetest.chat_send_all('not_attached!')
                        end

                    elseif new_node == 'default:apple' then
                        remove_tail = false
                        table.insert(arena.players[pl_name].nodes,1,new_pos)
                        --minetest.set_node(new_pos, {name="wormball:node_"..color})
                        wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)
                        arena.players[pl_name].score = arena.players[pl_name].score + 1
                        minetest.chat_send_player(pl_name,'You are now '..arena.players[pl_name].score..' long.')
                        local att = player:get_attach()
                        if att then
                            att:move_to(new_pos, true)
                        else
                            minetest.chat_send_all('not_attached!')
                        end

                    else
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
