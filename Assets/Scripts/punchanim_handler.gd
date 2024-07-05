extends Node3D

@onready var animPlayer = $ATK_HitBox/AttackAnim
# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer.play("Hit")
