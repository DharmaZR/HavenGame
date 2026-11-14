function EnemyMovement()
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

        var _gap  = (_dx > 0) ? _p.bbox_left - bbox_right : bbox_left - _p.bbox_right;
        var _same_height = _p.bbox_bottom >= bbox_top && _p.bbox_top <= bbox_bottom;

        if (_same_height && _gap <= attack_range) attacking = true;

        // keep walking until actually touching the player
        if (_dist <= chase_range && !place_meeting(x, y, _p)) hsp = facing * move_speed;
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

