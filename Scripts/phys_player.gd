extends RigidBody2D

const move_force: float = 10000.0
const jump_impulse: float = 700
const veloDamp = 6
const airVeloDamp = 1
const dashSpeed = 2000
const dashDuration = .4
const move_force_ratio: float = .17
const dashCooltime = .75
var hasDJ = true
var hasDash = true
var dashDirection = Vector2(0,0)
var onDashCool = false
@onready var dashTimer: Timer = $dashTimer
@onready var dashCoolTimer: Timer = $dashCoolTimer
@onready var raycast :RayCast2D = $RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dashTimer.timeout.connect(dashTimer_timeout)
	dashCoolTimer.timeout.connect(dashCoolTimer_timeout)
func dashTimer_timeout():
	pass
func dashCoolTimer_timeout():
	onDashCool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("Dash") and not dashTimer.time_left > 0 and hasDash and direction and not onDashCool:
		hasDash = false
		onDashCool = true
		dashDirection = direction
		dashTimer.start(dashDuration)
		dashCoolTimer.start(dashCooltime)
	if raycast.is_colliding():
		hasDJ = true
		hasDash = true
		if direction:
			apply_central_force(Vector2(direction*move_force,0))
		apply_central_force(linear_velocity*veloDamp*-1)
	else:
		if direction:
			apply_central_force(Vector2(direction*move_force*move_force_ratio,0))
		apply_central_force(linear_velocity*airVeloDamp*-1)
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if dashTimer.time_left > 0:
		state.linear_velocity = Vector2(dashDirection * dashSpeed * ((dashTimer.time_left  / dashDuration) + .4),0)
	if raycast.is_colliding():
		if Input.is_action_just_pressed("ui_accept"):
			state.linear_velocity.y = -jump_impulse
	else:
		if Input.is_action_just_pressed("ui_accept") and hasDJ:
			state.linear_velocity.y = -jump_impulse
			hasDJ = false
		
		
	
	

	
