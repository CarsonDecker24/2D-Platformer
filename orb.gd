extends Area2D
var speed: Vector2
var vel
var player
var homing
var dissapear_timer = 1

var marked_for_dissapear=false

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
	
	if marked_for_dissapear==true:
		dissapear_timer-=delta
		get_node("Collision").set_deferred("disabled",true)
		
		vel.x=0
		vel.y=0
		if dissapear_timer<=.8:
			get_node("AnimatedSprite2D").visible=false
		if dissapear_timer<=0:
			queue_free()

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
		_die()
	if body.is_in_group("Ground"):
		_die()

func _die():
	marked_for_dissapear=true
	get_node("ParticleCollide").emitting=true
	get_node("ParticleTrail").emitting=false
	
