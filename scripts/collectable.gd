extends Area2D

@onready var collectable = $"."
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

var readyToRemove: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	Gamemanager.score_change(1) # Score Increase
	collision_shape_2d.disabled = true
	readyToRemove = true
	collectable.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
