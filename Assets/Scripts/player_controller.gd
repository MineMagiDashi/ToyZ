extends CharacterBody3D


@export_category("General")
@export var health: int = 50
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

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if animPlayer.current_animation != "get_up":
			animPlayer.play("get_up")
	
	
	
	get_input(delta)
	get_utility(delta)
	get_atk_light(delta, false)
	move_and_slide()

func get_input(delta):
	
	# Get the input direction and handle the movement/deceleration.
	var currentInput = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (controlpivot.transform.basis * Vector3(currentInput.x, 0, currentInput.y)).normalized()
	if not usingutility:
		if direction:
			#Move 
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			
			#this function also works, the only difference is in slopes with a capsule mesh
			#self.global_translate(direction * speed * delta)

			if animPlayer.current_animation != "walking" and is_on_floor():
				animPlayer.play("walking")

			
			#Fix character looking up or down
			var lookingpos = position + direction
			lookingpos.y = position.y
			
			
			#Look at direction of movement
			model.look_at(lookingpos)
			#Change Last Direction
			lastDirection = direction
		else: #This stops the player from sliding forever; sets the velocity back to 0.
			if animPlayer.current_animation != "idle" and is_on_floor():
				animPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

#///////////////---UTILITY---///////////////

@export_category("Utility")
#Utility control variables
@export var dashMagnifier: float = 5
@export var utilityCount: int = 2
@onready var utilityUseTimer = $UtilityUseTimer
@onready var utilityCooldownTimer = $UtilityCooldownTimer
var usedutility: int = 0
var usingutility = false

func get_utility(delta):
	if Input.is_action_just_pressed("jump") and usedutility < utilityCount:
		
		#Make speed magnified
		if not usingutility:
			speed = speed * dashMagnifier
		#Check if they wanted to use dash attack
		if not dashAtkInputTimer.is_stopped():
			get_atk_light(delta,true)
		
		#Carry out tracking logic
		#If you want individual utility tracking, remove used utility if statement and change func _on_utility_cooldown_timer_timeout(): to "usedutility -= 1"
		if usedutility < 1:
			utilityCooldownTimer.start()
		usedutility += 1
		
		usingutility = true
		
		#Start timers to replenish uses
		utilityUseTimer.start()
		
		#Play animation
		if animPlayer.current_animation != "kick":
			animPlayer.play("kick")
		
	elif usingutility:
		#Move character forward
		var utilitydirection = model.global_transform.basis.z
		#velocity.x = -utilitydirection.x * speed * 50 * delta
		#velocity.z = -utilitydirection.z * speed * 50 * delta
		self.global_translate(-utilitydirection * speed * delta) #forces self up stairs compared to using velocity

func _on_utility_use_timer_timeout():
	usingutility = false
	speed = speed / dashMagnifier

func _on_utility_cooldown_timer_timeout():
	usedutility = 0
	clamp(usedutility, 0, utilityCount)
	if usedutility > 0:
		utilityCooldownTimer.start()

#///////////////---LIGHT ATTACK---///////////////
@export_category("Light Attack")
#Utility control variables

var Dummypunch1 = preload("res://Assets/Entities/Player/AttackHitboxes/basic_punch.tscn")
var Dummypunch2 = preload("res://Assets/Entities/Player/AttackHitboxes/basic_punch2.tscn")
var Dummypunch3 = preload("res://Assets/Entities/Player/AttackHitboxes/basic_punch2.tscn")
var Dummydashpunch = preload("res://Assets/Entities/Player/AttackHitboxes/punch_dash.tscn")

@onready var atkComboTimer = $AttackComboTimer
@onready var dashAtkInputTimer = $DashAtkInputTimer
var usingatk = false
var combo = 0

func play_hb(hitbox):
	var atk = hitbox.instantiate()
	var dir = lastDirection
	atk.position = dir
	atk.rotation = model.rotation
	add_child(atk)
	

func reset_combo():
	usingatk = false
	combo = 0

func get_atk_light(delta, isDashing):
	if Input.is_action_just_pressed("atk_light") and is_on_floor() and combo <= 2 or isDashing: #Check for input, if you're on the floor, if your combo is 2, or if you pressed attack and dash at the same time ish.
		#Start use timer for animation
		usingatk = true
		atkComboTimer.start()
		dashAtkInputTimer.start()
		
		#Play animation
		if animPlayer.current_animation != "kick":
			animPlayer.play("kick")
		
		
		#Check if the player isn't currently dashing.
		if not utilityUseTimer.is_stopped() or isDashing:
			print("DashPunch")
			play_hb(Dummydashpunch)
			reset_combo()
		else:
			#Instantiate and create hitbox where player is looking depending on combo number
			if combo == 0:
				print("Punch1")
				play_hb(Dummypunch1)
			elif combo == 1:
				print("Punch2")
				play_hb(Dummypunch2)
			elif combo == 2:
				print("Punch3")
				play_hb(Dummypunch3)
			#Up the combo number to string
			combo += 1

func _on_attack_combo_timer_timeout():
	reset_combo()
