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
var on_enemy = false
var current_attached_body

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
	elif type=="Ice":
		get_node("AnimatedSprite2D").play("ice arrow")
	elif type=="Fire":
		get_node("AnimatedSprite2D").play("fire arrow")
	else:
		get_node("AnimatedSprite2D").play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		_update_pos(delta)
	
	if player.arrow_count - id > 20:
		queue_free()

func _update_pos(delta):
	position += vel
	vel.y += GRAVITY * delta
	rotation = atan2(vel.y,vel.x)

func _multi(offset_angle):
	var arrow = arrowPath.instantiate()
	arrow._initialize_arrow(player.arrow_count, "MultiChild", vel.rotated(deg_to_rad(offset_angle)), angle + deg_to_rad(offset_angle), player)
	player.arrow_count += 1
	add_sibling(arrow)
	arrow.position = player.get_node("PivotHoldingArm/HoldingArmAnimation/ArrowSpawn").global_position
	arrow.rotation_degrees = angle + deg_to_rad(offset_angle)

func _on_body_entered(body):
	if body.is_in_group("Ground"):
		moving = false
		print("Hit Ground")
	if body.is_in_group("Enemy"):
		print("Hit Enemy")
		body._damage(type, 1)
		current_attached_body = body
		on_enemy = true
		moving = false
