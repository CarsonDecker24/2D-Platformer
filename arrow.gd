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

func _initialize_arrow(arrowType: String, arrowID: int, playerNode: Node):
	type = arrowType
	id = arrowID
	player = playerNode

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
		gravity_scale = 0
		
		sleeping= true
		#lock_rotation = true
		test=false

func _attach_to(body):
	offset = Vector2(position.x + body.position.x, position.y - body.position.y)
	position.x = body.position.x - offset.x
	position.y = body.position.y - offset.y
	linear_velocity.x=0
	linear_velocity.y=0
	gravity_scale = 0
	sleeping= true
	#lock_rotation = true
	test = false
	is_attached = true

func _keep_attached(body):
	#position = body.position - offset
	pass

func _detach():
	queue_free()
