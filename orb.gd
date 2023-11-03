extends Area2D
var speed: Vector2
var vel
var player
var homing

func _setup(s: Vector2, p: Node, isHoming):
	speed = s
	player = p
	homing = isHoming

# Called when the node enters the scene tree for the first time.
func _ready():
	vel = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if homing:
		vel.x = move_toward(vel.x, speed.rotated(_get_angle_to_player()).x, 2 * delta)
		vel.y = move_toward(vel.y, speed.rotated(_get_angle_to_player()).y, 2 * delta)
	position += vel

func _get_angle_to_player():
	if player != null:
		return global_position.angle_to_point(player.global_position)

func _on_area_entered(area):
	if area.is_in_group("Arrow"):
		if area.type == "Multi" or area.type == "MultiChild":
			_die()
	if area.is_in_group("Player"):
		print("Hit Player!")
		_die()
	if area.is_in_group("Ground"):
		_die()

func _on_body_entered(body):
	if body.is_in_group("Arrow"):
		if body.type == "Multi" or body.type == "MultiChild":
			_die()
	if body.is_in_group("Player"):
		print("Hit Player!")
	if body.is_in_group("Ground"):
		_die()

func _die():
	queue_free()
