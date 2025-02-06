extends Camera2D

@export var smoothing_enabled: bool = false # Whether smoothing is enabled
@export var smoothing_speed: float = 10 # Smoothing speed (higher = quicker follow)

@export var camera: Camera2D

func _ready():
	set_position_smoothing_enabled(smoothing_enabled)

func _process(delta):
		set_position_smoothing_speed(smoothing_speed)