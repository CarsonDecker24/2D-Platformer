extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Node2D/barrelPart1.freeze
	$Node2D/barrelPart2.freeze
	$Node2D/barrelPart3.freeze
	$Node2D/barrelPart4.freeze

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("Arrow"):
		$Node2D/barrelPart1.set_deferred("freeze", false)
		$Node2D/barrelPart2.set_deferred("freeze", false)
		$Node2D/barrelPart3.set_deferred("freeze", false)
		$Node2D/barrelPart4.set_deferred("freeze", false)
		
	pass # Replace with function body.
