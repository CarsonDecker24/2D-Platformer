extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _die():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("Arrow"):
		_die()
