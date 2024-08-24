extends RigidBody2D

@onready var timer = $KillZone/Timer

func _on_kill_zone_body_entered(body):
	if body.name == "Player":
		body.isDead = true
		body.get_node("CollisionShape2D").queue_free()
		body.get_node("AnimatedSprite2D").play("hurt")	
		timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
