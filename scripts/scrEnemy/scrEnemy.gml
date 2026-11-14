function enemy_init()
{
    move_speed     = 0.6;
    chase_range    = 160;
    attack_range   = 6; // edge-to-edge gap in pixels
    grav           = 0.3;
    max_fall       = 8;
    can_walk_off_ledges = false;
    sprite_faces_right = true;
    death_hop      = 3;

    hsp       = 0;
    vsp       = 0;
    facing    = 1;
    attacking = false;
    dead      = false;
	was_on_ground = place_meeting(x, y + 1, oWall);

    // sEarthSlime -> sEarthSlimeAttack, falls back to the base sprite if missing
    spr_move   = sprite_index;
    spr_attack = asset_get_index(sprite_get_name(sprite_index) + "Attack");
    if (spr_attack == -1) spr_attack = spr_move;

    mask_index = spr_move;
}

function enemy_stomp()
{
    if (dead) return;
    dead = true;
    global.enemies_killed++;
    attacking = false;
    sprite_index = spr_move;
    image_speed = 0;
    hsp = 0;
    vsp = -death_hop;
	audio_play_sound(DeathSound,3,false);
}

function enemy_draw()
{
    var _flip = sprite_faces_right ? (facing < 0) : (facing > 0);
    var _xs = image_xscale * (_flip ? -1 : 1);
    var _ys = image_yscale * (dead ? -1 : 1);
    var _dx = x;
    var _dy = y;

    // keep the sprite in its box when mirrored (origins are top-left)
    if (_flip) _dx += (sprite_get_width(sprite_index)  - 2 * sprite_get_xoffset(sprite_index)) * image_xscale;
    if (dead)  _dy += (sprite_get_height(sprite_index) - 2 * sprite_get_yoffset(sprite_index)) * image_yscale;

    draw_sprite_ext(sprite_index, image_index, _dx, _dy, _xs, _ys, 0, image_blend, image_alpha);
}
