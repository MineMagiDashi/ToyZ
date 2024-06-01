extends Area3D

@export var atk_damage = 10
@export var knockback_force = 100.0

@onready var HBExistTimer = $"../AttackHBExistTimer"
func _ready():
	HBExistTimer.start()


func _on_area_entered(body):
	if body.owner.has_method("take_damage"):
		var enemy = body.owner
		var attack = Attack.new()
		attack.attack_damage = atk_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		enemy.take_damage(attack)


func _on_attack_hb_exist_timer_timeout():
	self.owner.queue_free()
