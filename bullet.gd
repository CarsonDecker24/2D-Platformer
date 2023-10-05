extends RigidBody2D

func _process(delta): 
	pass

func _on_body_entered(body):
	if body.is_in_group("Ground"):
		freeze = true
