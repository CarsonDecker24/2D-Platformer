extends Node2D
var currentlyInWater = []
var searchHolder
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for x in currentlyInWater:
		x.wet=true
	
	
	
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		currentlyInWater.append(body)
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		searchHolder = currentlyInWater.bsearch(body)
		currentlyInWater.remove_at(searchHolder)
	pass # Replace with function body.
