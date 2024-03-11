extends Node2D

var targetPos
var currentPos
var targetAngle
var currentAngle
var player
var direction
var length = 110

var currentAngleVector
var targetAngleVector

#var life = 7

func _ready():
	$TargetRay.target_position = Vector2(-10000,0)

func _initialize(startAngle, playerNode):
	currentAngle = startAngle
	player = playerNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#life -= delta
	
	targetPos = player.global_position
	
	targetAngle = global_position.angle_to_point(targetPos)
	
	currentAngleVector = Vector2(cos(currentAngle), sin(currentAngle))
	targetAngleVector = Vector2(cos(targetAngle), sin(targetAngle)).normalized()
	
	currentAngleVector = currentAngleVector.move_toward(targetAngleVector, delta * .3)
	
	currentAngle = atan2(currentAngleVector.y , currentAngleVector.x)
	
	$TargetRay.target_position = Vector2(cos(currentAngle) * 10000, sin(currentAngle) * 10000)
	
	if $TargetRay.is_colliding():
		length = global_position.distance_to($TargetRay.get_collision_point())
		print("Length:")
		print(length)
	
	$TextureRect.size.x = length
	$TextureRect.rotation = currentAngle
	
	print("Angle to player:")
	print(rad_to_deg(targetAngle))
	print('Current Angle:')
	print(rad_to_deg(currentAngle))
	print($TextureRect.rotation)
