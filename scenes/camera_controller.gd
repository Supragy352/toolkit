extends Camera2D

@export var smoothing_speed: float = 5.0
@export var lookahead_distance: float = 50.0

var target_position: Vector2

func _process(delta):
    var player = get_parent()  # Assuming the camera is a child of the player
    if player:
        var lookahead_offset = Vector2(lookahead_distance * sign(player.velocity.x), 0)
        target_position = player.global_position + lookahead_offset
        
        # Smoothly move the camera using linear interpolation (lerp)
        global_position = global_position.lerp(target_position, 1.0 - exp(-smoothing_speed * delta))
