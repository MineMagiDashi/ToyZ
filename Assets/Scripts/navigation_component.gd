extends Node3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var ready_to_nav: bool  = false
@onready var entity = $".."

@export var movement_target: Node3D
@export var speed: float = 5.0
@export var accel: float = 3

func _ready():
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# store as bool so we never have to check again
	ready_to_nav = true
	
func _physics_process(delta):
	#Check if entity is ready to navigate
	if ready_to_nav:
		if nav_agent.target_position:
		#Make direction for movement
			var direction = Vector3()
			
			# Find designed TargetPosition
			nav_agent.target_position = movement_target.global_position
			
			# Change direction by finding next path in NavigationServer
			direction = nav_agent.get_next_path_position() - global_position
			direction = direction.normalized()
			
			#Move toward direction
			entity.velocity = direction * speed
			
			#Lerp method
			#velocity = velocity.lerp(direction * speed, accel * delta)
