extends Node2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_support_snap_area_area_entered(area):
	if area.is_in_group("Arrow"):
		$stickSupport.queue_free()
	pass # Replace with function body.

