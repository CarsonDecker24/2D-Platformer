extends Node2D
var startDelay=.2
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started ==true:
		startDelay-=delta
		$transition.self_modulate=Color(0, 0, 0, 1.0-(5*startDelay))
		$transition.z_index=2
		if startDelay<=0:
			get_tree().change_scene_to_file("res://level_1.tscn")
			
	pass
func _on_start_button_pressed():
	#change scene when putton pressed
	started=true
