extends PathFollow2D


@export var velocity = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_ratio += velocity * delta
