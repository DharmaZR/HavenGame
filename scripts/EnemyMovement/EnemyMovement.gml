EnemyMovement(); 

function EnemyMovement(){
    var _detect_dist = 150; 
    var _dist = distance_to_object(oPlayer); 

    if (_dist < _detect_dist) {
        sprite_index = sLavaSlimeAttack; 
        
        
        move_towards_point(oPlayer.x, oPlayer.y, 2); 
    } else {
        sprite_index = sEarthSlime; 
        speed = 0; 
    }
}
