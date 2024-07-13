extends Node3D
class_name UtilityComponent
#///////////////---UTILITY---///////////////

@export_category("Utility")
#Utility control variables
@export var dashMagnifier: float = 5
@export var utilityCount: int = 2
@export var m1Component: M1Component

@onready var player = get_parent()
@onready var utilityUseTimer = $UtilityUseTimer
@onready var utilityCooldownTimer = $UtilityCooldownTimer

@onready var speed = player.speed
@onready var animPlayer = $"../Visuals/AnimationPlayer"

var usedutility: int = 0
var usingutility = false

func _physics_process(delta):
	get_utility(delta)

func get_utility(delta):
	if Input.is_action_just_pressed("jump") and usedutility < utilityCount:
		
		#Make speed magnified
		if not usingutility:
			speed = speed * dashMagnifier
		#Check if they wanted to use dash attack
		if m1Component && m1Component.dashwindow == true:
			#Figure out why Window Dash Punch 'saves' the punch for whatever next input the player has.
			print("Window dash punch")
			m1Component.dashwindowutility = true
			m1Component.get_atk_light(delta)
		
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
		#Update player variable
		var player = get_parent()
		#Move character forward
		var utilitydirection = player.model.global_transform.basis.z
		#velocity.x = -utilitydirection.x * speed * 50 * delta
		#velocity.z = -utilitydirection.z * speed * 50 * delta
		player.global_translate(-utilitydirection * speed * delta) #forces self up stairs compared to using velocity

func _on_utility_use_timer_timeout():
	usingutility = false
	speed = speed / dashMagnifier

func _on_utility_cooldown_timer_timeout():
	usedutility = 0
	clamp(usedutility, 0, utilityCount)
	if usedutility > 0:
		utilityCooldownTimer.start()
