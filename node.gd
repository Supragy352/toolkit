extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = position.x + 10
