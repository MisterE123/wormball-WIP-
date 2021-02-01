
local function send_message(arena,num_str)
    arena_lib.HUD_send_msg_all("title", arena, "Game Begins In "..num_str, 1,nil,0xFF0000)
    -- ref: arena_lib.HUD_send_msg_all(HUD_type, arena, msg, <duration>, <sound>, <color>)
end

arena_lib.on_load("wormball", function(arena)

    --HUD countdown
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

                --only remove wormball-registered nodes
                local nodename = minetest.get_node({x=x,y=y,z=z}).name 
                if string.find(nodename,'wormball') then
                    minetest.set_node({x=x,y=y,z=z}, {name="air"})
                end
                
            end
        end
    end






    local idx = 1

    for pl_name, stats in pairs(arena.players) do

        --send control messages

        local message = 'Controls: Use look direction to steer, or press jump or sneak to move.  Dont bump anything!'
        minetest.chat_send_player(pl_name,message)
        local message = 'Eat dots to grow and get points, but your own color will shrink you!'
        minetest.chat_send_player(pl_name,message)
 
        local player = minetest.get_player_by_name(pl_name)
        local pos = player:get_pos()

        
        -- assign colors to players
        arena.players[pl_name].color = wormball.color_names[idx]


        
        --save players' textures so they can be made invisible
        wormball.player_texture_save[pl_name] = player:get_properties().textures
        --set their textures to invisible
        player:set_properties({textures = {'wormball_alpha.png'}})
        --set their first node (head) position
        arena.players[pl_name].nodes = {pos}
        local look_dir = wormball.get_look_dir(arena,player)
        wormball.place_node(  arena.players[pl_name].nodes  ,  {x=0,y=1,z=0}  ,  {x=0,y=1,z=0}  ,  look_dir,   arena.players[pl_name].color  )

        --determine whether it is singleplayer or multiplayer (singleplayer is set as default in arena temp props)
        if idx > 1 then
            arena.mode = 'multiplayer'
        end
        idx = idx + 1
    end

end)

