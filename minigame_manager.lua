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
        arena.players[pl_name].color = color

        arena.players[pl_name].nodes = {pos}
        minetest.set_node(pos, {name="wormball:node_"..color})
        
        idx = idx + 1
    end

end)


arena_lib.on_time_tick('wormball', function(arena)
    local remove_tail = true
    for pl_name, stats in pairs(arena.players) do
        if stats.alive == true then
            local player = minetest.get_player_by_name(pl_name)
            local color = stats.color
            --+x is forward, +z is left
            local control = player:get_player_control() --{jump=bool, right=bool, left=bool, LMB=bool, RMB=bool, sneak=bool, aux1=bool, down=bool, up=bool}
            local yaw = player:get_look_horizontal()
            if control.jump == true then 
                arena.players[pl_name].direction = {x=0,y=1,z=0}
            elseif control.sneak == true then
                arena.players[pl_name].direction = {x=0,y=-1,z=0}
            elseif yaw < (3.14*.25) or yaw > (3.14 *(7/4)) then -- if we are looking in the +z direction, 
                arena.players[pl_name].direction = {x=0,y=0,z=1}
            elseif yaw > (3.14*(1/4)) and yaw < (3.14 *(3/4)) then -- if we are looking in the -x direction
                arena.players[pl_name].direction = {x=-1,y=0,z=0}
            elseif yaw > (3.14*(3/4)) and yaw < (3.14 *(5/4)) then -- if we are looking in the -z direction
                arena.players[pl_name].direction = {x=0,y=0,z=-1}
            elseif yaw > (3.14*(5/4)) and yaw < (3.14 *(7/4)) then -- if we are looking in the +x direction
                arena.players[pl_name].direction = {x=1,y=0,z=0}
            end
            
            

            local new_move = stats.direction

            local head_pos = stats.nodes[1]

            local new_pos = {x = head_pos.x + new_move.x, y = head_pos.y + new_move.y, z = head_pos.z + new_move.z}

            local new_node = minetest.get_node(new_pos).name

            if new_node == 'air' then
                table.insert(arena.players[pl_name].nodes,1,new_pos)
                minetest.set_node(new_pos, {name="wormball:node_"..color})
                player:move_to(new_pos, true)

            elseif new_node == 'default:apple' then
                remove_tail = false
                table.insert(arena.players[pl_name].nodes,1,new_pos)
                minetest.set_node(new_pos, {name="wormball:node_"..color})
                arena.players[pl_name].score = arena.players[pl_name].score + 1
                minetest.chat_send_player(pl_name,'You are now '..arena.players[pl_name].score..' long.')
                player:move_to(new_pos, true)

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
                    arena_lib.remove_player_from_arena(pl_name, 1)
                    return
                end

            end

            --place an apple
            if math.random(1,3) == 1 then
                local apple_pos = {x = head_pos.x + math.random(-1,1)*math.random(1,4), y = head_pos.y + math.random(-1,1)*math.random(1,4), z = head_pos.z + math.random(-1,1)*math.random(1,4)}
                if minetest.get_node(apple_pos).name == 'air' then
                    minetest.set_node(apple_pos, {name='default:apple'})
                end
            end


        end

        if remove_tail == true then
            local len = #arena.players[pl_name].nodes
            local tail_pos = arena.players[pl_name].nodes[len]
            minetest.set_node(tail_pos, {name="air"})
            table.remove(arena.players[pl_name].nodes,len)
        end

        if #arena.players[pl_name].nodes == 0 then
            minetest.chat_send_player(pl_name, 'Your score is '..arena.players[pl_name].score)
            arena_lib.remove_player_from_arena(pl_name, 1)
        end

        
    end


end)




arena_lib.on_eliminate('wormball', function(arena, p_name)
    
    
    --minetest.chat_send_all(dump(arena))

    local count = 0
    local sound = 'sumo_elim'
    for p_name,data in pairs(arena.players) do
        count = count + 1
    end
    if count == 1 then
        sound = 'sumo_win'
    end

    for p_name, stats in pairs(arena.players) do
        

        minetest.sound_play(sound, {
            to_player = p_name,
            gain = 2.0,
        })        
    end


end)
