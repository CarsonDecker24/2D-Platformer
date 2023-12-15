extends Node2D
var armVel:Vector2
var armSpeed:Vector2 = Vector2(1,0)
var distance2Aim=0
var handSpeed = 300
@onready var chargePosition = $"../PivotHoldingArm/HoldingArmAnimation/pullArmPosition"
@onready var idlePosition= $"../PlayerBodyAnimation"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance2Aim = sqrt(pow((global_position.x-chargePosition.global_position.x),2) + pow((global_position.y-chargePosition.global_position.y),2))
	
	if ($"../PlayerBodyAnimation".current=="jumpIdleRight" or $"../PlayerBodyAnimation".current=="walkRightJump") and not (get_parent().fire_state== "aim" or get_parent().fire_state== "quick"):
		chargePosition.position.y = -2
		handSpeed=14
	elif ($"../PlayerBodyAnimation".current=="fallRight" or $"../PlayerBodyAnimation".current=="fallslowRight") and not (get_parent().fire_state== "aim" or get_parent().fire_state== "quick"):
			chargePosition.position.y = 1
			handSpeed= 14
	if (get_parent().fire_state== "aim" or get_parent().fire_state== "quick") or (not (get_parent().fire_state== "aim" or get_parent().fire_state== "quick") and ($"../PlayerBodyAnimation".current=="jumpIdleRight" or $"../PlayerBodyAnimation".current=="walkRightJump" or $"../PlayerBodyAnimation".current=="fallRight" or $"../PlayerBodyAnimation".current=="fallslowRight"))  and distance2Aim>1.15:
		armVel.x = move_toward(armVel.x, armSpeed.rotated(get_angle_to(chargePosition.global_position)).x,handSpeed*delta)
		armVel.y = move_toward(armVel.y, armSpeed.rotated(get_angle_to(chargePosition.global_position)).y,handSpeed*delta)
		position += armVel
		handSpeed = 300
	else:
		armVel.x=0
		armVel.y=0
	
	
	
	pass
