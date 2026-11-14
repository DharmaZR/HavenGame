if (instance_number(oGame) > 1) { instance_destroy(); exit; }
persistent = true;
depth = -10000;

global.total_bounces  = 0;
global.enemies_killed = 0;

fade_out_time = 0.4; // seconds
fade_in_time  = 0.4;
fade_col      = c_black;
music_gain    = 1;

fade        = 0;
state       = "none"; // "out", "in"
target_room = -1;
music       = noone;
music_inst  = -1;

room_music = function(_room)
{
    switch (_room)
    {
        case Title: return BackgroundMusic;
        case Cave:  return BackgroundMusic;
        case Test:  return BackgroundMusic;
        default:    return noone;
    }
}

update_music = function()
{
    var _track = room_music(room);
    if (_track == music) return;

    if (music_inst != -1) audio_stop_sound(music_inst);
    music      = _track;
    music_inst = -1;
    if (_track != noone)
    {
        music_inst = audio_play_sound(_track, 10, false, 0);
        audio_sound_gain(music_inst, music_gain, fade_in_time * 1000);
    }
}

next_room = function()
{
    var _next = room_next(room);
    go_to(_next == -1 ? room : _next);
}

restart_room = function()
{
    go_to(room);
}

go_to = function(_room)
{
    if (state != "none") return;
    state = "out";
    target_room = _room;

    // fade music only if the next room plays something else
    if (music_inst != -1 && room_music(target_room) != music)
        audio_sound_gain(music_inst, 0, fade_out_time * 1000);
}

frozen = function()
{
    return state == "out";
}

update_music();
