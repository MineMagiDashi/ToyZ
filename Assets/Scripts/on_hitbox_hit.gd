extends Area3D

@export var atk_damage = 10
@export var knockback_force = 100.0

@onready var HBExistTimer = $"../AttackHBExistTimer"
func _ready():
	HBExistTimer.start()


func _on_hitbox_area_entered(area):
	print("Hitbox entered area.") #Hitbox isnt even registering anything entering it. Start here.
	if area is HitboxComponent:
		print("Hitbox communicating with Component.")
		var hitbox : HitboxComponent = area

		var attack = Attack.new()
		attack.attack_damage = atk_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		area.damage(attack)


func _on_attack_hb_exist_timer_timeout():
	self.owner.queue_free()
