extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const bounciness = 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	global_rotation_degrees = 0
	if not is_on_floor():
		velocity.y += gravity * delta
	#var collision = move_and_collide(velocity*delta)
	#if collision:
		#velocity = velocity.bounce(collision.get_normal()) * bounciness
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
