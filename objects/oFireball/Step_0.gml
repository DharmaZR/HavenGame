if (oGame.frozen()) exit;

vsp += grav;
x += hsp;
y += vsp;

if (y > room_height + 64 || x < -64 || x > room_width + 64) instance_destroy();
