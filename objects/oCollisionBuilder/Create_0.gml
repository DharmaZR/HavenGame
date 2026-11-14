/// oCollisionBuilder - Create
// Reads the solid tile layer(s) and spawns invisible oWall instances
// wherever a tile is painted. Paint tiles, collision comes for free.
//
// Place ONE of these in every room (any layer is fine).
// Every non-empty tile on these layers counts as solid.
// Put decoration (background rocks, vines, etc.) on a DIFFERENT tile layer.

var _solid_layers = ["Tiles_1"];       // tile layer names that should be solid
var _wall_layer   = "Instances";       // instance layer the oWalls are created on

if (!layer_exists(_wall_layer)) layer_create(100, _wall_layer);

var _count = 0;

for (var l = 0; l < array_length(_solid_layers); l++)
{
    var _lay = layer_get_id(_solid_layers[l]);
    if (_lay == -1) { show_debug_message("oCollisionBuilder: no layer named " + _solid_layers[l]); continue; }

    var _map = layer_tilemap_get_id(_lay);
    if (_map == -1) { show_debug_message("oCollisionBuilder: layer " + _solid_layers[l] + " has no tileset"); continue; }

    var _tw   = tilemap_get_tile_width(_map);
    var _th   = tilemap_get_tile_height(_map);
    var _cols = tilemap_get_width(_map);
    var _rows = tilemap_get_height(_map);
    var _ox   = tilemap_get_x(_map);
    var _oy   = tilemap_get_y(_map);

    // Scan each row and merge horizontal runs of solid tiles into ONE wide oWall.
    // (Fewer instances = faster collision checks, and no seams to snag on.)
    for (var r = 0; r < _rows; r++)
    {
        var _run_start = -1;

        for (var c = 0; c <= _cols; c++)
        {
            var _solid = false;
            if (c < _cols) _solid = (tile_get_index(tilemap_get(_map, c, r)) != 0);

            if (_solid && _run_start == -1)
            {
                _run_start = c;                       // run begins
            }
            else if (!_solid && _run_start != -1)
            {
                var _len  = c - _run_start;           // run ended at c-1
                var _wall = instance_create_layer(_ox + _run_start * _tw, _oy + r * _th, _wall_layer, oWall);
                _wall.image_xscale = (_len * _tw) / sprite_get_width(sWall);
                _wall.image_yscale = _th / sprite_get_height(sWall);
                _run_start = -1;
                _count++;
            }
        }
    }
}

show_debug_message("oCollisionBuilder: created " + string(_count) + " oWall(s)");

instance_destroy(); // job done, no need to stick around
