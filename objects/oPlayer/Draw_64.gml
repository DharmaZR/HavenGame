var _b = meter_border;

var _bar = function(_x, _y, _pct, _col, _back)
{
    var _b = meter_border;
    draw_set_colour(c_black);
    draw_rectangle(_x, _y, _x + meter_w + _b * 2, _y + meter_h + _b * 2, false);
    draw_set_colour(_back);
    draw_rectangle(_x + _b, _y + _b, _x + _b + meter_w, _y + _b + meter_h, false);
    if (_pct > 0)
    {
        draw_set_colour(_col);
        draw_rectangle(_x + _b, _y + _b, _x + _b + meter_w * _pct, _y + _b + meter_h, false);
    }
}

// health
_bar(meter_x, meter_y, hp / hp_max, hp_col, hp_col_back);

draw_set_colour(c_black);
for (var i = 1; i < hp_max; i++)
{
    var _sx = meter_x + _b + meter_w * i / hp_max;
    draw_line(_sx, meter_y + _b, _sx, meter_y + _b + meter_h);
}

// jump
if (draw_jump_meter)
{
    var _pct = charge / charge_time;
    var _col = meter_col;
    if (_pct >= 1 && (flash_timer div meter_flash_rate) mod 2 == 0) _col = meter_col_full;

    _bar(meter_x, meter_y + meter_h + _b * 2 + meter_gap, _pct, _col, c_dkgray);
}

draw_set_colour(c_white);
