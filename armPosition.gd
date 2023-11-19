extends Node2D
var armVel:Vector2
var armSpeed:Vector2 = Vector2(1,0)
var distance2Aim=0
@onready var chargePosition = $"../PivotHoldingArm/HoldingArmAnimation/pullArmPosition"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance2Aim = sqrt(pow((global_position.x-chargePosition.global_position.x),2) + pow((global_position.y-chargePosition.global_position.y),2))
	
	
	if (get_parent().fire_state== "aim" or get_parent().fire_state== "quick") and distance2Aim>.3:
		armVel.x = move_toward(armVel.x, armSpeed.rotated(get_angle_to(chargePosition.global_position)).x,0.7)
		armVel.y = move_toward(armVel.y, armSpeed.rotated(get_angle_to(chargePosition.global_position)).y,0.7)
		position += armVel
	else:
		armVel.x=0
		armVel.y=0
	
	
	
	pass
