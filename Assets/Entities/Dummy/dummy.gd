extends CharacterBody3D

@export_category("General")
@export var maxHP: int = 50
@export var health: int = maxHP
@export var speed: float = 5.0
@export var accel: float = 3

@onready var respawn_timer = $RespawnTimer
@onready var skeleton = $Visuals/RootNode/Skeleton3D
@onready var health_bar = $Healthbar
@onready var hitbox = $MyHurtBox

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var ready_to_nav: bool  = false
@export var movement_target: Node3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var respawning = true
var isMoving = false

func _ready():
	call_deferred("actor_setup")
  

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# store as bool so we never have to check again
	ready_to_nav = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	#Check if entity is ready to navigate
	if ready_to_nav:
	#Make direction for movement
		var direction = Vector3()
		
		# Find designed TargetPosition
		nav_agent.target_position = movement_target.global_position
		
		# Change direction by finding next path in NavigationServer
		direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		
		#Move toward direction
		velocity = direction * speed
		
		#Lerp method
		#velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

func take_damage(attack: Attack):
	if health > 0:
		var dmg = attack.attack_damage
		var wasHP = health
		health -= dmg
		if health <= 0: health = 0
		print(self.name, " has taken ", dmg, " damage!")
		health_bar.update_health()
		if health == 0:
			self.set_collision_layer_value(3,false)
			hitbox.set_collision_layer_value(3,false)
			respawn_timer.start()
			skeleton.ragdollOn()
			#unused knockback code
			#velocity = (global_position - attack.attack_position).normalized()*attack.knockback_force

func _on_respawn_timer_timeout():
	self.set_collision_layer_value(3,true)
	hitbox.set_collision_layer_value(3,true)
	health = maxHP
	skeleton.ragdollOff()
	health_bar.update_health()

func get_debug_input():
	if Input.is_action_just_pressed("debug_G"):
		print("it's ya boi")
		
