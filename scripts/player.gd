extends CharacterBody2D

# Should change to "const" after adjusting the gameplay?
@export var speed : float = 500
@export var jump_velocity : float = -750
@export var jump_modifier_Up : float = 1 # Higher value could help with "floaty" feeling.
@export var jump_modifier_down : float = 3 # Affects gravity ONLY when inputing "Down" on a jump.

## Reference to the left joystick for input.
@export var joystick_left : VirtualJoystick
## Reference to the AnimatedSprite2D Node of the player.
@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called during the physics processing step of the main loop. 
# Physics processing means that the frame rate is synced to the physics, 
# i.e. the delta variable should be constant. delta is in seconds.
func _physics_process(delta):
	handle_input(delta)

## Controls the player movement, animation, and actions, based on input.
func handle_input(delta: float):
	# (Almost) All animations based on the current movement forces being executed.
	if not is_on_floor() and velocity.y<0:
		animated_sprite.play("jump_up")
	elif not is_on_floor() and velocity.y>0:
		animated_sprite.play("jump_down")		
	elif is_on_floor() and not velocity.x==0:
		animated_sprite.play("move")
	elif is_on_floor() and velocity.x==0:
		animated_sprite.play("idle")
	
	# Gets jump input, by reading the "ui_up" axis only.
	var jumpInput_Threshold : float = Input.get_action_strength("ui_up")
	# Gets "jump down"/crouching input, by reading the "ui_down" axis only.
	var downInput_Threshold : float = Input.get_action_strength("ui_down")
	# Gets input direction. Left or Right.
	var directionInput : float = Input.get_axis("ui_left","ui_right")
	
	# Handles shorting the Jump velocity by increasing the gravity.
	if not is_on_floor() and downInput_Threshold>0.5:
		velocity.y += gravity * delta * jump_modifier_down
	elif not is_on_floor():
		velocity.y += gravity * delta * jump_modifier_Up
	
	# Handles jump input.
	if jumpInput_Threshold>0.9 and is_on_floor():
		velocity.y = jump_velocity
	
	# Handles crouching or movement, CAN'T do both. Also idling.
	if downInput_Threshold>0.9 and is_on_floor():
		velocity.x = move_toward(0, 0, 0)
		animated_sprite.play("crouch")
	else:
		# Flips sprite according to input direction.
		if directionInput > 0:
			animated_sprite.flip_h = false
		elif directionInput < 0:
			animated_sprite.flip_h = true

		# Applies movement.
		if directionInput:
			velocity.x = directionInput * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
