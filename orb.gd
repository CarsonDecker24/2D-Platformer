extends Area2D
var speed
var vel
var player
var homing

func _setup(s: Vector2, p: Node, isHoming):
	speed = s
	player = p
	homing = isHoming

# Called when the node enters the scene tree for the first time.
func _ready():
	if not homing:
		vel = speed.rotated(_get_angle_to_player())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if homing:
		vel = speed.rotated(_get_angle_to_player())
	position += vel

func _get_angle_to_player():
	if player != null:
		return global_position.angle_to_point(player.global_position)
