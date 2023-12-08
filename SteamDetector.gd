extends Area2D
var on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _powered():
	on = true
	$AnimatedSprite2D.play("on")
func _unPowered():
	on = false
	$AnimatedSprite2D.play("off")
