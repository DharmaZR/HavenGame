target       = oPlayer;
follow_speed = 0.12; // 1 = locked to target
y_offset     = -16;

cam   = view_camera[0];
cam_x = camera_get_view_x(cam);
cam_y = camera_get_view_y(cam);

if (instance_exists(target))
{
    var _w = camera_get_view_width(cam);
    var _h = camera_get_view_height(cam);
    cam_x = clamp(target.x - _w / 2, 0, max(0, room_width  - _w));
    cam_y = clamp(target.y + y_offset - _h / 2, 0, max(0, room_height - _h));
    camera_set_view_pos(cam, round(cam_x), round(cam_y));
}
