// gravity
grav            = 0.35;
grav_dive       = 0.50;
max_fall        = 10;
max_fall_dive   = 14;

// air
air_accel       = 0.35;
air_max_speed   = 2.75;
air_turn_mult   = 2.0;
air_friction    = 0.37;

// hop
hop_vspeed      = 2.4;
hop_hspeed      = 0;
hop_delay       = 6;

// charged jump
jump_min = 2.0;
jump_max = 7.0;
charge_time = 20;

// bounce
bounce_keep = 0.70; // fraction of height kept on a neutral bounce
bounce_keep_nosuper = 0.40; // same, while super is used up
super_mult= 1.10;
super_max = 10;
bounce_min = 5.0;
ceiling_bounce  = 0.0;
stomp_bounce    = 6.0;

// health
hp_max        = 7;
hurt_iframes  = 60;
hurt_knock_h  = 2.5;
hurt_knock_v  = 4.0;
hurt_blink    = 4;

// no-super flash
nosuper_col = make_colour_rgb(150, 150, 150);
nosuper_rate  = 6; // frames per flash

// full charge flash
charged_alpha = 0.45;
charged_rate  = 4;

// animation
anim_jump_speed = 2.0;
anim_fall_speed = 1.0;

// jump meter (gui pixels)
meter_x = 16;
meter_y = 16;
meter_w = 200;
meter_h = 20;
meter_border = 2;
meter_gap = 4; // space between health and jump bars
hp_col = c_red;
hp_col_back = make_colour_rgb(70, 0, 0);
meter_col = c_yellow;
meter_col_full  = make_colour_rgb(255, 255, 170);
meter_flash_rate = 4; // frames per flash when full
draw_jump_meter = true;
debug_jump_meter = true;

// state
hsp = 0;
vsp = 0;
facing = 1;
grounded = false;
charging = false;
charge = 0;
was_hop = false;
hop_timer = hop_delay;
action_prev = false;
last_meter_step = -1;
bounce_count = 0;
super_used  = false;
flash_timer = 0;
hp = hp_max;
hurt_timer = 0;

mask_index = sPlayerIdle;

if (!instance_exists(oGame)) instance_create_depth(0, 0, -10000, oGame);
if (!instance_exists(oCamera)) instance_create_layer(x, y, layer, oCamera);

approach = function(_val, _target, _amt)
{
    return (_val < _target) ? min(_val + _amt, _target) : max(_val - _amt, _target);
}

launch = function(_speed, _is_hop)
{
    vsp      = -_speed;
    grounded = false;
    charging = false;
    charge   = 0;
    was_hop  = _is_hop;
}

land = function(_impact, _holding_action)
{
    if (_holding_action && !super_used && _impact >= bounce_min)
    {
        launch(min(_impact * super_mult, super_max), false);
        super_used = true;
        on_bounce(true);
    }
    else if (!was_hop && _impact >= bounce_min)
    {
        // height scales with speed squared
        var _keep = super_used ? bounce_keep_nosuper : bounce_keep;
        launch(min(_impact * sqrt(_keep), super_max), false);
        on_bounce(false);
    }
    else
    {
        grounded  = true;
        vsp       = 0;
        hsp       = 0;
        was_hop   = false;
        hop_timer = 0;
        super_used = false;
    }
}

hurt = function(_src)
{
    hp = max(hp - 1, 0);
    hurt_timer = hurt_iframes;

    var _dir = sign(x - (_src.bbox_left + _src.bbox_right) / 2);
    if (_dir == 0) _dir = -facing;
    hsp = _dir * hurt_knock_h;
    launch(hurt_knock_v, false);

    if (hp <= 0) room_restart();
}

on_bounce = function(_was_super)
{
    bounce_count++;
    // TODO: attack bar charge
}
