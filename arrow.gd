extends RigidBody2D
var test = true
var og_y_position
var grabbed_og=true
var vertical_change
var compared_to_previous
var is_attached = false
var has_been_attached = false
var on_enemy = false
var current_attached_body: Node
var offset = Vector2(0,0)
var type: String
var id: int
var player: Node
var charge
var angle
const arrowPath = preload("res://arrow.tscn")

func _initialize_arrow(arrowType: String, arrowID: int, chargeAmount, arrowAngle, playerNode: Node):
	type = arrowType
	id = arrowID
	charge = chargeAmount
	angle = arrowAngle
	player = playerNode

func _ready():
	if type == "Multi":
		_multi_arrow(5)
		_multi_arrow(-5)
	elif type=="Ice":
		get_node("AnimatedSprite2D").play("ice arrow")
	elif type=="Fire":
		get_node("AnimatedSprite2D").play("fire arrow")
	else:
		get_node("AnimatedSprite2D").play("default")

func _process(delta): 
	#Make arrow dip down after firing
	#if grabbed_og == false:
	#	compared_to_previous =  (og_y_position-global_position.y)-vertical_change
	
	#if grabbed_og == true:
	#	grabbed_og = false
	#	og_y_position = global_position.y
	#vertical_change = og_y_position-global_position.y
	
	if on_enemy:
		if current_attached_body == null:
			_detach()
		else:
			_keep_attached(current_attached_body)
	
	if player.arrow_count - id > 20:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Ground"):
		print("Hit Ground")
	if body.is_in_group("Enemy"):
		print("Hit Enemy")
		body._damage(type, 1)
		current_attached_body = body
		on_enemy = true
	if test:
		linear_velocity.x=0
		linear_velocity.y=0
		gravity_scale = 0.1
		
		sleeping= true
		#lock_rotation = true
		test=false

func _attach_to(body):
	#offset = Vector2(position.x + body.position.x, position.y - body.position.y)
	#position.x = body.position.x - offset.x
	#position.y = body.position.y - offset.y
	sleeping= true
	linear_velocity.x=0
	linear_velocity.y=0
	gravity_scale = 0.1
	#sleeping= true
	#lock_rotation = true
	test = false
	is_attached = true

func _keep_attached(body):
	#position = body.position - offset
	pass

func _detach():
	queue_free()

func _multi_arrow(offset_angle):
	var arrow = arrowPath.instantiate()
	arrow._initialize_arrow("MultiChild", player.arrow_count, charge, angle + offset_angle, player)
	player.arrow_count += 1
	add_sibling(arrow)
	arrow.position = player.get_node("PivotHoldingArm/HoldingArmAnimation/ArrowSpawn").global_position
	arrow.rotation_degrees = angle + offset_angle
	arrow.set_axis_velocity(Vector2(200*charge,0).rotated(arrow.rotation))

func _ice_arrow():
	#Change sprite to ice arrow
	pass


func _on_area_2d_body_entered(body):
	pass
