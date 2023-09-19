extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var curPlay 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move_right"):
		play("walk windup")
	pass


func _on_animation_timer_timeout():
	print("timeout")
	pass # Replace with function body.
