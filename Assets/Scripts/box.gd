extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func take_damage():
	print("Hit the box!")
	queue_free()
