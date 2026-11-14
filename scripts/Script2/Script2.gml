function enemy_init()
{
    move_speed     = 0.6;
    chase_range    = 160;
    attack_range   = 20;
    grav           = 0.3;
    max_fall       = 8;
    stay_on_ledges = true;
    sprite_faces_right = true;
    death_hop      = 3;

    hsp       = 0;
    vsp       = 0;
    facing    = 1;
    attacking = false;
    dead      = false;

    // sEarthSlime -> sEarthSlimeAttack, falls back to the base sprite if missing
    spr_move   = sprite_index;
    spr_attack = asset_get_index(sprite_get_name(sprite_index) + "Attack");
    if (spr_attack == -1) spr_attack = spr_move;

    mask_index = spr_move;
}

function enemy_step()
{
 
    if (dead)
    {
        vsp += grav;
        y += vsp;
        if (y > room_height + 64) instance_destroy();
        return;
    }

    hsp = 0;
    attacking = false;

    var _p = instance_nearest(x, y, oPlayer);
    if (_p != noone)
    {
        var _cx = (bbox_left + bbox_right) / 2;
        var _cy = (bbox_top + bbox_bottom) / 2;
        var _dx = _p.x - _cx;
        var _dist = point_distance(_cx, _cy, _p.x, _p.y);

        if (abs(_dx) > 1) facing = sign(_dx);

        if (_dist <= attack_range) {
            attacking = true;
        }
        else if (_dist <= chase_range) {
            hsp = facing * move_speed;
            
            if (floor(image_index) == 0 && !audio_is_playing(SlimeBounce)) {
                var _snd = audio_play_sound(SlimeBounce, 1, false);
                audio_sound_gain(_snd, 2, 1);
                audio_sound_gain(_snd, 0, 200);
            }
        }
    }

    var _on_ground = place_meeting(x, y + 1, oWall);
    if (stay_on_ledges && _on_ground && hsp != 0)
    {
        var _half = (bbox_right - bbox_left) / 2;
        if (!place_meeting(x + facing * _half, y + 1, oWall)) hsp = 0;
    }

    vsp = min(vsp + grav, max_fall);

    if (hsp != 0)
    {
        if (place_meeting(x + hsp, y, oWall))
        {
            var _s = sign(hsp);
            repeat (ceil(abs(hsp)) + 1)
            {
                if (place_meeting(x + _s, y, oWall)) break;
                x += _s;
            }
            hsp = 0;
        }
        else x += hsp;
    }

    if (place_meeting(x, y + vsp, oWall))
    {
        var _sv = sign(vsp);
        repeat (ceil(abs(vsp)) + 1)
        {
            if (place_meeting(x, y + _sv, oWall)) break;
            y += _sv;
        }
        vsp = 0;
    }
    else y += vsp;

    var _spr = attacking ? spr_attack : spr_move;
    if (sprite_index != _spr) { sprite_index = _spr; image_index = 0; }
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
	audio_play_sound(DeathSound,2,false);
}

function enemy_draw()
{
    var _flip = sprite_faces_right ? (facing < 0) : (facing > 0);
    var _xs = image_xscale * (_flip ? -1 : 1);
    var _ys = image_yscale * (dead ? -1 : 1);
    var _dx = x;
    var _dy = y;

   
    if (_flip) _dx += (sprite_get_width(sprite_index)  - 2 * sprite_get_xoffset(sprite_index)) * image_xscale;
    if (dead)  _dy += (sprite_get_height(sprite_index) - 2 * sprite_get_yoffset(sprite_index)) * image_yscale;

    draw_sprite_ext(sprite_index, image_index, _dx, _dy, _xs, _ys, 0, image_blend, image_alpha);
}
