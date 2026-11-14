flash_timer++;

if (!dead && hurt_timer > 0 && (flash_timer div hurt_blink) mod 2 == 0) exit;

var _col = image_blend;
if (!dead && super_used &&(flash_timer div nosuper_rate) mod 2 == 0) _col = nosuper_col;

draw_sprite_ext(sprite_index, image_index, x, y, facing, 1, 0, _col, image_alpha);

if (charging && charge >= charge_time && (flash_timer div charged_rate) mod 2 == 0)
{
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, facing, 1, 0, c_white, charged_alpha);
    gpu_set_blendmode(bm_normal);
}
