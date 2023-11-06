extends Area2D

#Instance Variables
var vel: Vector2
var angle
var type: String
var player: Node
var id
var moving = true
const GRAVITY = 5
var arrowPath = preload("res://new_arrow.tscn")
@onready var ray = get_node("RayCast2D")
var on_enemy = false
var current_attached_body
var collision_point
#@onready var diePart = get_node("diePart")
var dyingTime=1
var dying = false
var hideNextFrame = false

func _initialize_arrow(aID, aType: String, aVel: Vector2, aAngle, aPlayer: Node):
	id = aID
	type = aType
	vel = aVel
	angle = aAngle
	player = aPlayer
	

func _process(delta):
	if moving:
		_update_pos(delta)
	
	if hideNextFrame:
		#get_node("AnimatedSprite2D").visible = false
		pass
	
	if dying:
		if dyingTime<0:
			print("die")
		dyingTime-=delta
		if dyingTime<.95:
			get_node("AnimatedSprite2D").set_modulate(Color(1, 1, 1, 0))

func _update_pos(delta):
	position += vel
	vel.y += GRAVITY * delta
	ray.target_position = vel
	if not hideNextFrame:
		_check_ray()
	rotation = atan2(vel.y,vel.x)

func _check_ray():
	if ray.get_collider() != null:
		collision_point = ray.get_collision_point()
		#particle.position = collision_point
		hideNextFrame = true
