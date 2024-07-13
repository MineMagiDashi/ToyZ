extends Node3D

@export var MAX_HEALTH := 50.0
var health : float

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	if health > 0:
		var dmg = attack.attack_damage
		health -= dmg
		if health <= 0: health = 0
		if health <= 0:
			get_parent().queue_free()
			#unused knockback code
			#velocity = (global_position - attack.attack_position).normalized()*attack.knockback_force

func _process(float):
	if Input.is_action_just_pressed("debug_G"):
		debugdmg(10.0)

func debugdmg(amount: float):
	print("Damaging player")
	var attack = Attack.new()
	attack.attack_damage = amount
	damage(attack)

