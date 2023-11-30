extends Area2D

var on = false
var turnOffTimer = 0

func _process(delta):
	if on:
		$AnimatedSprite2D.play("on")
	else:
		$AnimatedSprite2D.play("off")
	
	if on and turnOffTimer <= 0:
		turnOffTimer = 10
	elif on:
		turnOffTimer -= delta
	if on and turnOffTimer <= 0:
		on = false
	

func _turn_on():
	on = true


func _on_body_entered(body):
	pass
