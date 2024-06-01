extends Skeleton3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var e = false
func ragdollOn():
	physical_bones_start_simulation()
	
func ragdollOff():
	physical_bones_stop_simulation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
