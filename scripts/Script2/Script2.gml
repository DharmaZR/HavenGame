
function enemy_init()
{
    // Movement settings
    move_speed = 2.0;
    chase_range = 160;
    stop_distance = 16;

    // Jump physics
    grav = 0.3;
    max_fall = 8;
    jump_speed = 4.5;

    stay_on_ledges = true;
    sprite_faces_right = true;

    // Death settings
    death_hop = 3;

    // Initialize variables
    hsp = 0;
    vsp = 0;
    facing = 1;

    attacking = false;
    dead = false;

    image_speed = 1;

    // Store idle sprite
    spr_move = sprite_index;

    // Find matching jumping sprite
    spr_attack = asset_get_index(
        sprite_get_name(sprite_index) + "Attack"
    );

    // Use idle sprite if attack sprite doesn't exist
    if (spr_attack == -1)
    {
        spr_attack = spr_move;
    }

    // Keep collision mask consistent
    mask_index = spr_move;
}


function enemy_step()
{
    // --------------------------------
    // DEAD ENEMY
    // --------------------------------

    if (dead)
    {
        vsp = min(vsp + grav, max_fall);
        y += vsp;

        if (y > room_height + 64)
        {
            instance_destroy();
        }

        return;
    }


    // --------------------------------
    // FIND PLAYER
    // --------------------------------

    hsp = 0;
    attacking = false;

    var _p = instance_nearest(x, y, oPlayer);

    if (_p != noone)
    {
        var _cx = (bbox_left + bbox_right) / 2;
        var _cy = (bbox_top + bbox_bottom) / 2;

        var _dx = _p.x - _cx;

        var _dist = point_distance(
            _cx, _cy,
            _p.x, _p.y
        );

        // Face the player
        if (abs(_dx) > 1)
        {
            facing = sign(_dx);
        }

        // Chase player
        if (_dist <= chase_range && _dist > stop_distance)
        {
            attacking = true;
            hsp = facing * move_speed;
        }
    }


    // --------------------------------
    // CHECK GROUND
    // --------------------------------

    var _on_ground = place_meeting(x, y + 2, oWall);
	// TEMPORARY DEBUGGING
if (!variable_instance_exists(id, "debug_count"))
{
    debug_count = 0;
}

debug_count++;

if (debug_count mod 60 == 0)
{
    var _debug_player = instance_nearest(x, y, oPlayer);

    var _debug_dist = -1;

    if (_debug_player != noone)
    {
        _debug_dist = point_distance(
            x, y,
            _debug_player.x, _debug_player.y
        );
    }

    show_debug_message(
        "ENEMY: " + object_get_name(object_index)
        + " | Player distance: " + string(_debug_dist)
        + " | Ground: " + string(_on_ground)
        + " | Chasing: " + string(attacking)
        + " | HSP: " + string(hsp)
    );
}


    // --------------------------------
    // LEDGE DETECTION
    // --------------------------------

    if (stay_on_ledges && _on_ground && hsp != 0)
    {
        var _half = (bbox_right - bbox_left) / 2;

        if (!place_meeting(x + facing * _half, y + 1, oWall))
        {
            hsp = 0;
        }
    }
	var _wall_ahead = place_meeting(x + facing * 4, y, oWall);

var _ledge_ahead = !place_meeting(
    x + facing * ((bbox_right - bbox_left) / 2),
    y + 1,
    oWall
);

show_debug_message(
    "X: " + string(x)
    + " | Y: " + string(y)
    + " | Wall ahead: " + string(_wall_ahead)
    + " | Ledge ahead: " + string(_ledge_ahead)
    + " | VSP: " + string(vsp)
    + " | HSP: " + string(hsp)
);


    // --------------------------------
    // JUMP TOWARD PLAYER
    // --------------------------------

    // Jump whenever grounded and chasing
    if (attacking && _on_ground && hsp != 0)
    {
        vsp = -jump_speed;
    }


    // --------------------------------
    // GRAVITY
    // --------------------------------

    vsp = min(vsp + grav, max_fall);


    // --------------------------------
    // HORIZONTAL MOVEMENT
    // --------------------------------

    if (hsp != 0)
    {
        if (place_meeting(x + hsp, y, oWall))
        {
            var _s = sign(hsp);

            repeat (ceil(abs(hsp)) + 1)
            {
                if (place_meeting(x + _s, y, oWall))
                {
                    break;
                }

                x += _s;
            }

            hsp = 0;
        }
        else
        {
            x += hsp;
        }
    }


    // --------------------------------
    // VERTICAL MOVEMENT
    // --------------------------------

    if (place_meeting(x, y + vsp, oWall))
    {
        var _sv = sign(vsp);

        repeat (ceil(abs(vsp)) + 1)
        {
            if (place_meeting(x, y + _sv, oWall))
            {
                break;
            }

            y += _sv;
        }

        vsp = 0;
    }
    else
    {
        y += vsp;
    }


    // --------------------------------
    // SPRITE SWITCHING
    // --------------------------------

    var _spr = attacking ? spr_attack : spr_move;

    if (sprite_index != _spr)
    {
        sprite_index = _spr;
        image_index = 0;
        image_speed = 1;
    }
}


function enemy_stomp()
{
    if (dead) return;

    dead = true;
    attacking = false;

    sprite_index = spr_move;
    image_speed = 0;

    hsp = 0;
    vsp = -death_hop;
}


function enemy_draw()
{
    // Horizontal flipping
    var _flip = sprite_faces_right
        ? (facing < 0)
        : (facing > 0);

    var _xs = image_xscale * (_flip ? -1 : 1);

    // Flip vertically when dead
    var _ys = image_yscale * (dead ? -1 : 1);

    var _dx = x;
    var _dy = y;

    // Adjust sprite origin
    if (_flip)
    {
        _dx += (
            sprite_get_width(sprite_index)
            - 2 * sprite_get_xoffset(sprite_index)
        ) * image_xscale;
    }

    if (dead)
    {
        _dy += (
            sprite_get_height(sprite_index)
            - 2 * sprite_get_yoffset(sprite_index)
        ) * image_yscale;
    }

    draw_sprite_ext(
        sprite_index,
        image_index,
        _dx,
        _dy,
        _xs,
        _ys,
        0,
        image_blend,
        image_alpha
    );
}
