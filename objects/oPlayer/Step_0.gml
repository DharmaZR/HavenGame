if (oGame.frozen()) { image_speed = 0; exit; }
image_speed = 1;

var _dir = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
var _jump = keyboard_check(vk_space) || keyboard_check(vk_up) || keyboard_check(ord("W"));
var _down = keyboard_check(vk_down) || keyboard_check(ord("S"));
var _jump_released = action_prev && !_jump;
action_prev = _jump;

if (_dir != 0) facing = _dir;

// falling
if (grounded && !place_meeting(x, y + 1, oWall))
{
    grounded = false;
    charging = false;
    charge   = 0;
}

// ground code
if (grounded)
{
    hsp = 0;
    vsp = 0;

    if (_jump)
    {
        // charge
        charging = true;
        charge   = min(charge + 1, charge_time);

        if (debug_jump_meter)
        {
            var _pct  = charge / charge_time;
            var _step = floor(_pct * 10);
            if (_step != last_meter_step)
            {
                last_meter_step = _step;
                show_debug_message("JUMP [" + string_repeat("#", _step) + string_repeat("-", 10 - _step) + "] " + string(round(_pct * 100)) + "%");
            }
        }
    }
    else if (charging && _jump_released)
    {
        // releasing
        var _pct = charge / charge_time;
        if (debug_jump_meter) show_debug_message("LAUNCH at " + string(round(_pct * 100)) + "%");
        last_meter_step = -1;
        launch(lerp(jump_min, jump_max, _pct), false);
    }
    else if (_dir != 0)
    {
        // baby hop when pressing l or r
        hop_timer++;
        if (hop_timer >= hop_delay)
        {
            hsp = _dir * hop_hspeed;
            launch(hop_vspeed, true);
        }
    }
    else
    {
        hop_timer = hop_delay; 
    }
}

// airboren code
if (!grounded)
{
    // hold down to fall faster... super smash bros ref omg
    var _dive = _down && !super_used;
    var _g   = _dive ? grav_dive     : grav;
    var _cap = _dive ? max_fall_dive : max_fall;
    vsp = min(vsp + _g, _cap);

    // turn in air
    if (_dir != 0)
    {
        var _acc = air_accel;
        if (hsp != 0 && sign(hsp) != _dir) _acc *= air_turn_mult;
        hsp = approach(hsp, _dir * air_max_speed, _acc);
    }
    else
    {
        hsp = approach(hsp, 0, air_friction);
    }
}

// collion (x)
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

// stomp
if (vsp > 0)
{
    var _e = instance_place(x, y + vsp, oEnemy);
    if (_e != noone && !_e.dead && bbox_bottom <= _e.bbox_top + 1)
    {
        with (_e) enemy_stomp();
        launch(stomp_bounce, false);
        on_bounce(false);
    }
}

// Vertical
if (vsp != 0)
{
    if (place_meeting(x, y + vsp, oWall))
    {
        var _sv = sign(vsp);
        repeat (ceil(abs(vsp)) + 1)
        {
            if (place_meeting(x, y + _sv, oWall)) break;
            y += _sv;
        }

        if (vsp > 0) land(vsp, _down);           // hit the floor
        else         vsp = -vsp * ceiling_bounce;  // hit a ceiling
    }
    else y += vsp;
}

// end of level
if (bbox_right >= room_width - 1) oGame.next_room();

// damage
if (hurt_timer > 0) hurt_timer--;
else
{
    var _src = noone;
    with (oEnemy) if (!dead && (place_meeting(x, y, other) || place_meeting(x + facing, y, other))) { _src = id; break; }

    if (_src == noone) _src = instance_place(x, y + 1, oHazard);
    if (_src == noone) _src = instance_place(x, y - 1, oHazard);
    if (_src == noone) _src = instance_place(x + 1, y, oHazard);
    if (_src == noone) _src = instance_place(x - 1, y, oHazard);

    if (_src != noone) hurt(_src);
}

// animating
var _spr;
if (grounded)
{
    if (charging) _spr = (charge >= charge_time) ? sPlayerDown2 : sPlayerDown1;
    else _spr = sPlayerIdle;
}
else
{
    if (vsp < -anim_jump_speed) _spr = sPlayerJump;
    else if (vsp >  anim_fall_speed) _spr = sPlayerFall;
    else _spr = sPlayerIdle;
}
if (sprite_index != _spr) { sprite_index = _spr; image_index = 0; }

