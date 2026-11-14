EnemyMovement();
if (dead || oGame.frozen()) exit;

if (fire_timer > 0) fire_timer--;
if (anim_timer > 0) anim_timer--;

var _p = instance_nearest(x, y, oPlayer);
if (_p != noone && !_p.dead)
{
    var _cx = (bbox_left + bbox_right) / 2;
    var _px = _p.x;
    var _py = (_p.bbox_top + _p.bbox_bottom) / 2;

    if (fire_timer <= 0 && point_distance(_cx, y, _px, _py) <= fire_range)
    {
        shoot(_cx + (_px - _cx) * undershoot, _py);
        shots_left = 1;
        shot_timer = fire_gap;
        fire_timer = fire_cooldown * game_get_speed(gamespeed_fps);
    }
    else if (shots_left > 0 && --shot_timer <= 0)
    {
        shoot(_px, _py);
        shots_left = 0;
    }
}

var _spr = (anim_timer > 0) ? spr_attack : spr_move;
if (sprite_index != _spr) { sprite_index = _spr; image_index = 0; }
