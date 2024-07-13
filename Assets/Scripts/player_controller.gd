extends CharacterBody3D


@export_category("General")
@export var speed: float = 5.0

@export_group("Unused")
@export var jump_velocity: float = 4.5

@export_category("Animation")
@export var locomotionBlendPath: String
@export var animationTree: AnimationTree
@export var transitionSpeed: float = 0.1

@onready var model = $Visuals #Different way of using _ready():
@onready var controlpivot = $ControlPivot #The controls moving diagonally for isometric
@onready var animPlayer = $Visuals/AnimationPlayer

var lastDirection = self.position

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if animPlayer.current_animation != "get_up":
			animPlayer.play("get_up")
	
	get_input(delta)
	move_and_slide()

func get_input(delta):
	
	# Get the input direction and handle the movement/deceleration.
	var currentInput = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (controlpivot.transform.basis * Vector3(currentInput.x, 0, currentInput.y)).normalized()
	if not $PlyrUtilityComponent.usingutility:
		if direction:
			#Move 
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			
			#this function also works, the only difference is in slopes with a capsule mesh
			#self.global_translate(direction * speed * delta)

			if animPlayer.current_animation != "walking" and is_on_floor():
				animPlayer.play("walking")

			
			#Look at direction of movement
			var lookingpos = position + direction
			lookingpos.y = position.y
			model.look_at(lookingpos)
			#Change Last Direction
			lastDirection = direction
		else:
			#Stop the player from sliding forever
			if animPlayer.current_animation != "idle" and is_on_floor():
				animPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
