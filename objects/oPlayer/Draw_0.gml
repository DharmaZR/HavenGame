flash_timer++;

var _col = image_blend;
if (super_used && (flash_timer div nosuper_rate) mod 2 == 0) _col = nosuper_col;

draw_sprite_ext(sprite_index, image_index, x, y, facing, 1, 0, _col, image_alpha);
