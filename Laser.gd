extends Node2D

var targetPos
var currentPos
var targetAngle
var currentAngle
var player

var life = 7

func _ready():
	$TargetRay.target_position = Vector2(10000,0)

func _initialize(startAngle, playerNode):
	currentPos = startAngle
	player = playerNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life -= delta
	
	targetPos = player.global_position
	
	targetAngle = position.angle_to(targetPos)
	
	currentAngle.move_toward(targetAngle, .1 * delta)
	
	$TargetRay.rotation = currentAngle

func _set_length():
	pass
