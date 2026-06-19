extends RigidBody2D

@export var move_force: float = 10000.0
@export var move_force_ratio: float = .3
@export var jump_impulse: float = 4000.0
@onready var raycast :RayCast2D = $RayCast2D
var veloDamp = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if raycast.is_colliding():
		move_force_ratio = .3
		if direction:
			apply_central_force(Vector2(direction*move_force,0))
		if Input.is_action_just_pressed("ui_accept"):
			apply_central_impulse(Vector2(0,-jump_impulse))
	else:
		if direction:
			apply_central_force(Vector2(direction*move_force*move_force_ratio,0))
		if move_force_ratio > .1:
			move_force_ratio -= .003
	apply_central_force(linear_velocity*veloDamp*-1)
	

	
