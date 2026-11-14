var _fps = game_get_speed(gamespeed_fps);

if (state == "out")
{
    fade = min(fade + 1 / max(1, fade_out_time * _fps), 1);
    if (fade >= 1)
    {
        state = "in";
        room_goto(target_room);
    }
}
else if (state == "in")
{
    fade = max(fade - 1 / max(1, fade_in_time * _fps), 0);
    if (fade <= 0) state = "none";
}
