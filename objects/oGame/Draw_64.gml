if (room == End)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(end_text_col);
    draw_text(display_get_gui_width() / 2, display_get_gui_height() / 2, end_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(c_white);
}

if (fade <= 0) exit;

draw_set_alpha(fade);
draw_set_colour(fade_col);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_colour(c_white);
