extends CharacterBody3D

@export_category("General")
@export var speed: float = 5.0
@export var accel: float = 3

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var respawning = true
var isMoving = false
 
func _physics_process(delta):
	if not is_on_floor():
		# Add the gravity.
		velocity.y -= gravity * delta
	move_and_slide()
