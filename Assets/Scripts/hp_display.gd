extends Sprite3D
class_name HealthBarComponent

@onready var displayBar = $SubViewport/TextureProgressBar

@export var healthcomponent : HealthComponent

#Colors for health bars. Need to divide by 255, as Godot uses RAW by default instead of RGB or HSV.
var green = Color(30,255,45,255)/255.0
var orange = Color(255,125,30,255)/255.0
var red = Color(255,30,30,255)/255.0

func _ready():
	update_health() #Update health display on spawn.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_health():
	#Find the health percentage
	var spritePercentage = healthcomponent.health * 100.0 / healthcomponent.MAX_HEALTH
	
	#Create smoothing tween.
	var tween = create_tween()
	tween.tween_property(displayBar, "value", spritePercentage, 0.2) # Change 'displayBar.value' in 0.2 seconds
	
	if spritePercentage == 100: #Check if the entity is spawning or respawning. O/W will get stuck in middle orange lerp.
		displayBar.tint_progress = green
	elif displayBar.value > 50: #If above 50, lerp from green to orange
		displayBar.tint_progress = lerp(orange, green, spritePercentage / 100)
	elif displayBar.value < 50: #If below 50, lerp from orange to red
		displayBar.tint_progress = lerp(red, orange, spritePercentage / 100)
