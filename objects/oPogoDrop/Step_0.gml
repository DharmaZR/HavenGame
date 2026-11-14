vsp = min(vsp + grav, max_fall);
x += hsp;
y += vsp;

if (bbox_top > room_height + 64) instance_destroy();
