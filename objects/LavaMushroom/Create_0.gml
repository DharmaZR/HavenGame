event_inherited();

move_speed     = 0;
fire_range     = 128; // how close the player gets before it shoots
fire_cooldown  = 4;   // seconds
fire_gap       = 20;  // frames between the two fireballs
arc_height     = 64;  // min height of the arc above the mushroom
undershoot     = 0.6; // first shot lands this fraction of the way to the player
fireball_grav  = 0.2;
fire_anim      = 15;  // frames to show the attack sprite after a shot

fire_timer  = 0;
shots_left  = 0;
shot_timer  = 0;
anim_timer  = 0;

shoot = function(_tx, _ty)
{
    var _sx = (bbox_left + bbox_right) / 2;
    var _sy = bbox_top;
    var _g  = fireball_grav;

    var _apex = min(_sy - arc_height, _ty - 16);
    var _up   = _sy - _apex;
    var _down = max(_ty - _apex, 0);
    var _vy   = -sqrt(2 * _g * _up);
    var _t    = sqrt(2 * _up / _g) + sqrt(2 * _down / _g);

    var _w = sprite_get_width(sFireball) / 2;
    var _h = sprite_get_height(sFireball) / 2;
    var _f = instance_create_depth(_sx - _w, _sy - _h, depth - 1, oFireball);
    _f.grav = _g;
    _f.vsp  = _vy;
    _f.hsp  = (_tx - _sx) / _t;

    anim_timer = fire_anim;
}
