extends CharacterBody2D

@export var speed : float = 130
@export var jump_velocity : float = -300

@export var joystick_left : VirtualJoystick

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_vector := Vector2.ZERO

func _physics_process(delta):
	## Movement using the joystick output:
#	if joystick_left and joystick_left.is_pressed:
#		position += joystick_left.output * speed * delta
	if not is_on_floor():
		velocity.y += gravity * delta
		## Movement using Input functions:
		position += move_vector * speed * delta
	
	# Handle jump.
	if Input.get_action_strength("ui_up")>0.75 and is_on_floor():
		velocity.y = jump_velocity
	
	var direction = Input.get_axis("ui_left","ui_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Apply movement
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
