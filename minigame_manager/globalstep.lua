--this minigame has a globalstep to update the board, because the arena_lib on_time_tick 
--is too slow for the fast-paced nature of snake. However, lag has been tested to be low 
--(please confirm as needed)





minetest.register_globalstep(function(dtime)

    --every server_step, check if the players in-game are attached to their worm heads. Iff they are not, then spawn a new entity and attach them
    --note, the entities have a 10 min timeout (wormball games last 5 min). A MT 5.3 engine bug can detach players unexpectedly, this is a workaround.

    for _,player in ipairs(minetest.get_connected_players()) do
        local pl_name = player:get_player_name()

        if arena_lib.is_player_in_arena(pl_name, "wormball") then
            local arena = arena_lib.get_arena_by_player(pl_name)
            if not(arena.in_queue == true) and not (arena.in_loading == true) and not(arena.in_celebration == true) and arena.enabled == true then 
                local stats = arena.players[pl_name]
                if stats.alive == true then
                    if not player:get_attach() then
                        local pos_head = arena.players[pl_name].nodes[1]
                        local att = minetest.add_entity(pos_head, 'wormball:player_att')

                        player:set_attach(att, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
                    end
                end
            end
        end
    end


    --we will only run worm movement code about every 0.4 seconds, if not 0.4 seconds yet; return

    wormball.timer = wormball.timer+dtime
    if wormball.timer < .4 then return
    end
    --reset the timer
    wormball.timer = 0
    


    --because this is a global callback, I have to get the name from the player, and the arena from the name, and check that the
    --arena is in-game before doing anything

    --check all connected players
    for _,player in ipairs(minetest.get_connected_players()) do

        local pl_name = player:get_player_name()

        --only mess with stuff if they are in the wormball minigame
        if arena_lib.is_player_in_arena(pl_name, "wormball") then

            local arena = arena_lib.get_arena_by_player(pl_name)

            --only mess with stuff if the arena is in-game, add they are supposed to be attached
            if not(arena.in_queue == true) and not (arena.in_loading == true) and not(arena.in_celebration == true) and arena.enabled == true and arena.players[pl_name].attached == true then 
                
                ----------------------------------------------
                ---- mimic the normal for pl_name, stats  ----
                ----------------------------------------------
                local stats = arena.players[pl_name]
                
                local color = stats.color

                local remove_tail = true



                -- if players are alive, move the worms (add to the length, subtract from the tail)

                if stats.alive == true then                    


                    local old_dir = arena.players[pl_name].old_direction or {x=0,y=1,z=0} --grab the old_dir info before its updated

                    local player = minetest.get_player_by_name(pl_name)

                    local control = player:get_player_control() --ref: {jump=bool, right=bool, left=bool, LMB=bool, RMB=bool, sneak=bool, aux1=bool, down=bool, up=bool}

                    local look_dir = wormball.get_look_dir(arena,player) --in globals file; returns a string, one of: px, nx, pz, nz for the approximation of player look direction
                    
                    local died = false --used to determine whether to elim player

                    --get player direction from current input, first check up or down, then look direction

                    if control.jump == true then --if we are going up
                        arena.players[pl_name].direction = {x=0,y=1,z=0}
                    elseif control.sneak == true then --if we are going down
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

                    
                    
                    
                    -- localize the direction for easy reference
                    local new_move = stats.direction
                    --was:stats.direction

                    --stats.nodes is the positions of the worm body parts, idx 1 is the head
                    local head_pos = stats.nodes[1]
                
                    --get the new head pos, from the old pos and the new move pos
                    local new_pos = {x = head_pos.x + new_move.x, y = head_pos.y + new_move.y, z = head_pos.z + new_move.z}

                    --get the node at the tenative new head location. 
                    local new_node = minetest.get_node(new_pos).name


                    ----------------------------------------------
                    --- if the new node is air, move the head, delete the tail, length remains the same
                    --- if the new node is a powerup of a different color, move the head, but keep the tail, so the snake grows 1
                    --- if the new node is a powerup of the same color, set move to false, so the next round, the head will not be moved as the tail is deleted to shrink it
                    --- if the new node is none of the above, it is an obstacle, and the player loses
                    ----------------------------------------------
                    --- note: if stats.move is set to false, then the next round, the head will not move, but move will be reset
                    --- note: if the local var remove_tail is true, then after checking the node, the tail is removed
                    -----------------
                    --- note: the function wormball.place_node is in the globals file, and performs the math to place the head and the 
                    ---      -- first body segment rotated according to the current and previous movement directions.
                    ----------------------------------------------
                    --- note: we ALWAYS move forward, unless there is an arena obstacle. However, for the dots of the same color, 
                    ---      -- we do not move forward NEXT turn. This is so that dots are always *eaten*
                    ----------------------------------------------
                    
                    if new_node == 'air' then

                        
                        if arena.players[pl_name].move == true then 

                            -- place the head location into the player's body locations table
                            table.insert(arena.players[pl_name].nodes,1,new_pos)

                            --draw the head and the first body segment
                            wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)


                            --move the player's attached entity (use invisible entities so movements are smoother)
                            local att = player:get_attach()

                            --nil check
                            if att then
                                att:move_to(new_pos, true)
                            end

                        else
                            arena.players[pl_name].move = true
                        end

                        
                    elseif new_node == "wormball:power_"..color then --oops, hit own color, remove 1 length

                        

                        if arena.players[pl_name].move == true then


                            --delete the memory of the dot that was 'eaten'
                            for _,dot in pairs(arena.dots) do
                                if dot == new_pos then
                                    table.remove(arena.dots,_)
                                end
                            end
                            

                            -- place the head location into the player's body locations table
                            table.insert(arena.players[pl_name].nodes,1,new_pos)


                            --draw the head and the first body segment
                            wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)

                            --subtract 1 from the player's score
                            arena.players[pl_name].score = arena.players[pl_name].score - 1

                            --send an HUD message
                            arena_lib.HUD_send_msg('broadcast', pl_name, 'YUCK! You Lost a point.', 2, 'wormball_yuck',0xFF0000)


                            --move the player's attached entity
                            local att = player:get_attach()
                            if att then
                                att:move_to(new_pos, true)
                            end

                            --we will be removing the tail, to visually shorten the worm
                            remove_tail = true

                            --we will not be moving forward NEXT turn (after eating a same color dot)
                            arena.players[pl_name].move = false

                        else
                            arena.players[pl_name].move = true
                        end

                        
                        

                    elseif string.find(new_node,'wormball:power_') then --we found a powerup dot!



                        if arena.players[pl_name].move == true then

                            --delete the memory of the dot that was 'eaten'
                            for _,dot_pos in pairs(arena.dots) do
                                if dot_pos == new_pos then
                                    table.remove(arena.dots,_)
                                end
                            end

                            

                            -- place the head location into the player's body locations table
                            table.insert(arena.players[pl_name].nodes,1,new_pos)


                            --draw the head and the first body segment                            
                            wormball.place_node(arena.players[pl_name].nodes,arena.players[pl_name].direction,old_dir,look_dir,color)


                            -- add 1 to the player's score
                            arena.players[pl_name].score = arena.players[pl_name].score + 1


                            -- send HUD message
                            arena_lib.HUD_send_msg('broadcast', pl_name, 'Yay! You are now '..arena.players[pl_name].score..' long.', 2, 'wormball_powerup',0x00FF11)
                            

                            --move the player's attached entity
                            local att = player:get_attach()
                            if att then
                                att:move_to(new_pos, true)
                            end

                            --we will be not removing the tail this round, we are growing
                            remove_tail = false

                        else
                            arena.players[pl_name].move = true
                        end


                    else --we have run into an arena obstacle, another snake, or ourselves set died to true so the player will be removed and their peices converted



                        if not arena.in_celebration then

                            
                            arena.players[pl_name].alive = false 
                            
                            died = true


                        end


                        
                    end

                end


                ----------------------------------------------------------------------------
                --- the following code we run regardless of whether the player is alive or not
                ----------------------------------------------------------------------------
                
                if remove_tail == true then --true by default, only false when having eaten a 'good' dot

                    local len = #arena.players[pl_name].nodes --worm length

                    local tail_pos = arena.players[pl_name].nodes[len] --position to change

                    if tail_pos then --nil check

                        -- if the player is dead, then we will slowly convert them into food (of their color)
                        -- if they are still alive, then we will place air there to delete the tail
                        if arena.players[pl_name].alive == false then 
                            local item = "wormball:power_"..color
                            minetest.set_node(tail_pos, {name=item}) 
                        else
                            minetest.set_node(tail_pos, {name="air"}) 
                        end
                        --forget the tail position in the player's body postions
                        table.remove(arena.players[pl_name].nodes,len)
                    end
                end

                -- if players have no nodes, eliminate them. (this can happen if they eat a 'bad' dot while only 1 long) if they have run into an obstacle, elim also
                if #arena.players[pl_name].nodes == 0 or died == true then   --if you eat a bad powerup with only 1 point, then you lose!
                    
                    minetest.chat_send_player(pl_name, 'Game Over! Your score is '..arena.players[pl_name].score)
                    minetest.chat_send_player(pl_name, "You did not make the highscore list because you did not survive for the full game! Try again!")

                    for _,node_pos in pairs(arena.players[pl_name].nodes) do 
                        local item = "wormball:power_"..color
                        minetest.set_node(node_pos, {name=item})
                    end
                    arena.players[pl_name].alive = false
                    
                    wormball.detach(pl_name)         
                    minetest.sound_play('sumo_lose', {
                        to_player = pl_name,
                        gain = 2.0,
                    })                                 
                    arena_lib.remove_player_from_arena(pl_name, 1)
                end
            end
        end

    end
end)








