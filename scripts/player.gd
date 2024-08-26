extends CharacterBody2D

# Should change to "const" after adjusting the gameplay?
var speed: float = 700
const speedFixed : float = 700
var jump_velocity : float = -1350 # Consider this the true "jump strength" setting.
# This values modify gravity as multipliers while jumping.
var jump_mod_normal : float = 2 # Higher value could help with "floaty" feeling, if player sprite is too big.
var jump_mod_inputdown : float = 5 # Affects gravity ONLY when inputing "Down" on a jump, to help control ascending faster.

## Reference to the left joystick for input.
@export var joystick_left : VirtualJoystick
## Reference to the AnimatedSprite2D Node of the player.
@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## Jump input, by reading the "ui_up" axis only. From 0 to 1.
var jumpInput_Threshold : float = 0
## "Jump Down"/Crouch input, by reading the "ui_down" axis only. From 0 to 1.
var downInput_Threshold : float = 0
## Input direction. Left or Right. From -1 to 1.
var directionInput : float = 0

var isDead = false

# Animation flags. Blocks script from calling the same animation multiple times.
var jumpingUp : bool = false
var jumpingDown : bool = false
var attackFalling : bool = false

# Called during the physics processing step of the main loop. 
# Physics processing means that the frame rate is synced to the physics, 
# i.e. the delta variable should be constant. delta is in seconds.
func _physics_process(delta):
	if not isDead:
		handle_animations()
		handle_movement_input(delta)
	

## (Almost) All animations based on the current movement forces being executed.
func handle_animations():
	# Flips sprite according to input direction.
	if directionInput > 0:
		animated_sprite.flip_h = false
	elif directionInput < 0:
		animated_sprite.flip_h = true
	
	# Resets jump animation flags.
	if is_on_floor():
		jumpingDown = false
		jumpingUp = false
		attackFalling = false
	
	# Movement and jumping animations		
	if not is_on_floor() and velocity.y<0 and not jumpingUp and not attackFalling:
		jumpingUp = true
		animated_sprite.play("jump_up")
	elif not is_on_floor() and velocity.y>0.1 and not jumpingDown and not attackFalling:
		jumpingDown = true
		animated_sprite.play("jump_down")
	elif not is_on_floor() and attackFalling:
		animated_sprite.play("attack") 		
	elif is_on_floor() and not velocity.x==0:
		animated_sprite.play("move")
	elif is_on_floor() and velocity.x==0:
		animated_sprite.play("idle")


## Controls the player movement and actions, based on input.
func handle_movement_input(delta: float):
	# Gets jump input, by reading the "ui_up" axis only.
	jumpInput_Threshold = Input.get_action_strength("ui_up")
	# Gets "jump down"/crouching input, by reading the "ui_down" axis only.
	downInput_Threshold = Input.get_action_strength("ui_down")
	# Gets input direction. Left or Right.
	directionInput = Input.get_axis("ui_left","ui_right")
	
	# "Normalizes" directionInput to maintain constant forces.
	if directionInput > 0.1:
		directionInput = 1
	elif directionInput < 0.1:
		directionInput = -1
	
	# Handles shorting the Jump velocity by increasing the gravity.
	if not is_on_floor() and downInput_Threshold>0.5:
		velocity.y += gravity * delta * jump_mod_inputdown
		attackFalling = true
	elif not is_on_floor():
		velocity.y += gravity * delta * jump_mod_normal
	
	# Handles jump input.
	if jumpInput_Threshold>0.5 and is_on_floor():
		velocity.y = jump_velocity
	
	# Handles crouching or movement, CAN'T do both. Also idling.
	if downInput_Threshold>0.5 and is_on_floor():
		velocity.x = move_toward(0, 0, 0)
		animated_sprite.play("crouch")
	else:
		# Changes speed if player is on air to increase air movility.
		if is_on_floor():
			speed = speedFixed
		else:
			speed = speedFixed*1.2
		# Applies movement.
		if directionInput != 0:
			velocity.x = directionInput * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
