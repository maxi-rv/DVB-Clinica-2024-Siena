extends Area2D

@onready var timer = $Timer

var player 
@export var initial_y_position = 1450

func _ready():
	# Attempt to find the player node by its name
	player = get_node("Player")
	if player:
		initial_y_position = global_position.y
	else:
		print("Player node not found")

func _process(delta):
	global_position.y = initial_y_position
	# Update only the X position to follow the player
	if player:
		global_position.x = player.global_position.x

func _on_body_entered(body):
	# Engine.time_scale = 0.5
	print(body.name)
	if body.name == "Player":
		body.get_node("AnimatedSprite2D").play("hurt")
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	else: 
		print("Other body detected", body.name)

func _on_timer_timeout():
	Engine.time_scale = 1.0
	Gamemanager.reset_score()
	get_tree().reload_current_scene()
