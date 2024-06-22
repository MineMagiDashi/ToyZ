extends Node3D
class_name HealthComponent

@export var health_bar : HealthBarComponent
@export var hitbox : HitboxComponent
@export var respawn_timer : Timer
@export var skeleton : Skeleton3D

@export var MAX_HEALTH := 10.0
var health : float

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	if health > 0 || !respawn_timer:
		var dmg = attack.attack_damage
		var wasHP = health
		health -= dmg
		if health <= 0: health = 0
		print(self.name, " has taken ", dmg, " damage!")
		health_bar.update_health()
		if health <= 0 || respawn_timer:
			get_parent().set_collision_layer_value(3,false)
			hitbox.set_collision_layer_value(3,false)
			respawn_timer.start()
			if skeleton:
				skeleton.ragdollOn()
		else:
			get_parent().queue_free()
			#unused knockback code
			#velocity = (global_position - attack.attack_position).normalized()*attack.knockback_force
			
func _on_respawn_timer_timeout():
	get_parent().set_collision_layer_value(3,true)
	hitbox.set_collision_layer_value(3,true)
	health = MAX_HEALTH
	skeleton.ragdollOff()
	health_bar.update_health()
