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
@onready var particle = get_node("particles")
@onready var diePart = get_node("diePart")
var dyingTime=1
var dying = false
var hideNextFrame = false

func _initialize_arrow(aID, aType: String, aVel: Vector2, aAngle, aPlayer: Node):
	id = aID
	type = aType
	vel = aVel
	angle = aAngle
	player = aPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if type == "Multi":
		_multi(5)
		_multi(-5)
		get_node("AnimatedSprite2D").play("default")
		particle.gravity.y=0
		particle.color=Color(0.408, 0.408, 0.408, 0.8)
		particle.initial_velocity_max=5
		particle.tangential_accel_max=0
		particle.radial_accel_max=0
	elif type=="Ice":
		get_node("AnimatedSprite2D").play("ice arrow")
		particle.color=Color(0, 0.686, 0.984, 0.8)
		particle.radial_accel_max=40
	elif type=="Fire":
		get_node("AnimatedSprite2D").play("fire arrow")
		particle.gravity.y=-60
		particle.color=Color(1, 0.145, 0, 0.655)
		particle.initial_velocity_max=5
		particle.radial_accel_max=0
	elif type == "Wind":
		_wind()
		queue_free()
	else:
		get_node("AnimatedSprite2D").play("default")
		particle.color=Color(0.408, 0.408, 0.408, 0.8)
		particle.gravity.y=0
		particle.initial_velocity_max=5
		particle.tangential_accel_max=0
		particle.radial_accel_max=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		_update_pos(delta)
	
	if hideNextFrame==true:
		get_node("AnimatedSprite2D").visible = false
	
	if dying:
		if dyingTime<0:
			queue_free()
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

func _multi(offset_angle):
	var arrow = arrowPath.instantiate()
	arrow._initialize_arrow(player.arrow_count, "MultiChild", vel.rotated(deg_to_rad(offset_angle)), angle + deg_to_rad(offset_angle), player)
	player.arrow_count += 1
	add_sibling(arrow)
	arrow.position = player.get_node("PivotHoldingArm/HoldingArmAnimation/ArrowSpawn").global_position
	arrow.rotation_degrees = angle + deg_to_rad(offset_angle)

func _wind():
	player._dash(player.get_local_mouse_position().normalized(),-500)

func _check_ray():
	if ray.get_collider() != null:
		collision_point = ray.get_collision_point()
		particle.position = collision_point
		hideNextFrame = true

func _on_body_entered(body):
	if body.is_in_group("Ground"):
		moving = false
		if type=="Fire":
			diePart.color=Color(1, 0.145, 0, 0.655)
		if type=="Ice":
			diePart.color=Color(0, 0.686, 0.984, 0.7)
			diePart.speed_scale=2.5
		if type=="Multi":
			diePart.color = Color(1, 1, 1, 0.545)
		
		diePart.emitting=true
		#get_node("AnimatedSprite2D").set_modulate(Color(1, 1, 1, 0))
		dying=true
		particle.emitting=false
		
	if body.is_in_group("Enemy"):
		print("Hit Enemy")
		body._damage(type, 1)
		current_attached_body = body
		on_enemy = true
		moving = false
		if type=="Fire":
			diePart.color=Color(1, 0.145, 0, 0.655)
		if type=="Ice":
			diePart.color=Color(0, 0.686, 0.984, 0.7)
			diePart.speed_scale=2.5
		if type=="Multi":
			diePart.color = Color(1, 1, 1, 0.545)
		
		diePart.emitting=true
		#get_node("AnimatedSprite2D").set_modulate(Color(1, 1, 1, 0))
		dying=true
		particle.emitting=false
	

