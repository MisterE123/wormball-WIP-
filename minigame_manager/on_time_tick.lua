

arena_lib.on_time_tick('wormball', function(arena)
    
    ----------------------------------------------
    ----------------------------------------------
    --  send HUD with time, set color based on time left
    ----------------------------------------------
    ----------------------------------------------


    local c = 0x00FF00
    if arena.current_time < 60 then
        c = 0xFFFF00
    end
    if arena.current_time < 10 then
        c = 0xFF0000
    end

    if arena.current_time < arena.initial_time - 5 then
        arena_lib.HUD_send_msg_all('hotbar', arena, 'TIME: '..arena.current_time, 1,nil,c)
    end

    
    ----------------------------------------------
    ----------------------------------------------
    --  set powerups within the arena   ----------
    ----------------------------------------------
    ----------------------------------------------


    -- get the arena area points from settings, order them
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


    --get a local table of color names
    local color_table = wormball.color_names
    

    --get current number of players
    local num_players = 0
    for pl_name,stats in pairs(arena.players) do
        num_players = num_players +1
    end


    --decide whether to (have a chance of) removing dots
    local remove = false
    if #arena.dots and #arena.dots> arena.min_food_factor * num_players + arena.min_food then
        remove = true
    end


    --add dots, with greater chance with more players
    for pl_name,stats in pairs(arena.players) do
        --random location within arena
        local rand_pos = {x = math.random(x1,x2),y = math.random(y1,y2), z=math.random(z1,z2)}
        local item = 'none'
        --random chance to place random color
        if math.random(1,3)== 1 then
            local color = color_table[math.random(1,#color_table)]
            item = "wormball:power_"..color
        end
        --if you want to place other nodes instead/also, set item here...


        if item ~= 'none' then
            if minetest.get_node(rand_pos).name == 'air' then --only place in air (not replace arena or worms or other powerups)
                minetest.set_node(rand_pos, {name=item})
                table.insert(arena.dots,rand_pos) --keep track of where powerups (dots) are
            end
        end
        if remove then
            --if there are enough powerups to remove some, have a 0.5 chance of removing them
            if math.random(1,2) == 1 then
                local rem_pos = table.remove(arena.dots,math.random(4,#arena.dots)) --forget the pos of removed powerup
                if not(string.find(minetest.get_node(rem_pos).name,"wormball:straight_")) 
                and not(string.find(minetest.get_node(rem_pos).name,"wormball:corner_"))
                and not(string.find(minetest.get_node(rem_pos).name,"wormball:head_")) then

                    minetest.set_node(rem_pos, {name="air"})

                end
            end
        end
    end
end)



