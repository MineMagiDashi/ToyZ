extends Node3D
class_name M1Component

# The general idea behind this component (and future components that come after it) is to make this
# specific component the 'default' M1 you get in the game. Upgrades further in the game give different
# types of M1 combos and simply replace this node with another node that changes the behavior.

@onready var player = get_parent()
@onready var animPlayer = $"../Visuals/AnimationPlayer"
@onready var lastDirection = player.position

@export var visuals : Node3D
@export var utilityComponent: UtilityComponent

#///////////////---LIGHT ATTACK---///////////////
@export_category("Light Attack")
#Utility control variables

var Dummypunch1 = preload("res://Assets/Entities/Player/AttackHitboxes/basic_punch.tscn")
var Dummypunch2 = preload("res://Assets/Entities/Player/AttackHitboxes/basic_punch2.tscn")
var Dummypunch3 = preload("res://Assets/Entities/Player/AttackHitboxes/basic_punch2.tscn")
var Dummydashpunch = preload("res://Assets/Entities/Player/AttackHitboxes/punch_dash.tscn")

@onready var atkComboTimer = $AttackComboTimer
@onready var dashAtkWindowTimer = $DashAtkWindowTimer
var usingatk = false
var combo = 0
var dashwindow = false
var dashwindowutility = false

func _physics_process(delta):
	get_atk_light(delta)

func play_hb(hitbox):
	var atk = hitbox.instantiate()
	var dir = lastDirection
	atk.position = dir
	atk.rotation = player.model.rotation
	add_child(atk)

func reset_combo():
	usingatk = false
	combo = 0

func get_atk_light(delta):
	#If on the floor, if combo is 2, or if currently dashing.
	if Input.is_action_just_pressed("atk_light") and player.is_on_floor() and combo <= 2:
		#Start use timer for animation
		usingatk = true
		atkComboTimer.start()
		dashAtkWindowTimer.start()
		dashwindow = true
		
		#Play animation
		if animPlayer.current_animation != "kick":
			animPlayer.play("kick")
		
		
		#Check if the player is dashing
		if dashwindowutility == true or utilityComponent.usingutility == true:
			print("DashPunch")
			play_hb(Dummydashpunch)
			reset_combo()
			dashwindowutility = false
		else: #If not, do normal combo
			#Instantiate hitbox where player is looking depending on combo number
			if combo == 0:
				print("Punch1")
				play_hb(Dummypunch1)
			elif combo == 1:
				print("Punch2")
				play_hb(Dummypunch2)
			elif combo == 2:
				print("Punch3")
				play_hb(Dummypunch3)
			#Up the combo number
			combo += 1

func _on_attack_combo_timer_timeout():
	reset_combo()


func _on_dash_atk_input_timer_timeout():
	dashwindow = false
