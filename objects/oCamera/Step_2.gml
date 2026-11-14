if (!instance_exists(target)) exit;
if (variable_instance_exists(target, "dead") && target.dead) exit;

var _w = camera_get_view_width(cam);
var _h = camera_get_view_height(cam);

var _tx = clamp(target.x - _w / 2, 0, max(0, room_width  - _w));
var _ty = clamp(target.y + y_offset - _h / 2, 0, max(0, room_height - _h));

cam_x = lerp(cam_x, _tx, follow_speed);
cam_y = lerp(cam_y, _ty, follow_speed);

camera_set_view_pos(cam, round(cam_x), round(cam_y));
