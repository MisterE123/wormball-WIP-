wormball.version = "02.03.2021.3"


wormball.player_texture_save = {}


--lookup tables


--colors: a list of color codes, indexed by name
wormball.colors = {yellow = "fcba0388", 
                  orangered = "fc280388", 
                  darkred = "a1000088", 
                  lightgreen = "80ff0088", 
                  aqua = "00ff8488",
                  lightblue = "0084ff88",
                  darkblue = "0d00ff88",
                  purple = "8000ff88",
                  lightpurple = "ee00ff88",
                  pink = "ff006f88"}

--color_names: a list of color names, indexed by number
wormball.color_names = {}
local i=1
for color,code in pairs(wormball.colors) do
    wormball.color_names[i] = color
    i=i+1
end

--reference tables for placing node rotations properly
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


-- timer: a counter for keeping track of global step stuff
wormball.timer = 0



--place_node: a custom function for placing the head and second segment every movement. Uses rotation lookup tables above

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


--get_look_dir: a custom function that returns a simplified player look direction in the form of a direction code, that place_node uses
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



-- detaches player, resets texture

wormball.detach = function(p_name)
    local player = minetest.get_player_by_name(p_name) or nil

    --set texture back to normal... dont worry about disconnects... player_api handles setting textures on_join
    if player and wormball.player_texture_save[p_name] ~= nil then --nil checks
        player:set_properties({textures = wormball.player_texture_save[p_name]})
    end
    --detach and remove attachment entity, play losing sound
    if player then
        local att = player:get_attach()
        player:set_detach()
        if att then att:remove() end
    end






end
