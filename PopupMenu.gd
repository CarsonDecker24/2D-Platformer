extends PopupMenu


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y=$"../invintoryListPosition".global_position.y-$"../../../Camera".global_position.y+324
	position.x=$"../invintoryListPosition".global_position.x-$"../../../Camera".global_position.x+612
	pass
