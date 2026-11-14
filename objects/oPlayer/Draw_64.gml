if (!draw_jump_meter) exit;

var _pct = charge / charge_time;
var _b   = meter_border;

draw_set_colour(c_black);
draw_rectangle(meter_x, meter_y, meter_x + meter_w + _b * 2, meter_y + meter_h + _b * 2, false);

draw_set_colour(c_dkgray);
draw_rectangle(meter_x + _b, meter_y + _b, meter_x + _b + meter_w, meter_y + _b + meter_h, false);

if (_pct > 0)
{
    var _col = meter_col;
    if (_pct >= 1 && (flash_timer div meter_flash_rate) mod 2 == 0) _col = meter_col_full;

    draw_set_colour(_col);
    draw_rectangle(meter_x + _b, meter_y + _b, meter_x + _b + meter_w * _pct, meter_y + _b + meter_h, false);
}

draw_set_colour(c_white);
