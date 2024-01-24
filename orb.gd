extends Area2D
var speed: Vector2
var vel
var player
var homing
var disappear_timer = 1
var parried = false
var fixTurn

var marked_for_disappear=false

func _setup(s: Vector2, p: Node, isHoming,turned):
	speed = s
	player = p
	#homing = isHoming
	homing = false
	fixTurn=turned

# Called when the node enters the scene tree for the first time.
func _ready():
	vel = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if homing==true:
		if fixTurn==true:
			vel.x = move_toward(vel.x, speed.rotated(_get_angle_to_player()).x, 3 * delta)
			vel.y = move_toward(vel.y, speed.rotated(_get_angle_to_player()).y, 3 * delta)
		else:
			vel.x = move_toward(vel.x, -speed.rotated(_get_angle_to_player()).x, 3 * delta)
			vel.y = move_toward(vel.y, -speed.rotated(_get_angle_to_player()).y, 3 * delta)
	position += vel * delta
	
	if marked_for_disappear==true:
		disappear_timer-=delta
		get_node("Collision").set_deferred("disabled",true)
		
		vel.x=0
		vel.y=0
		if disappear_timer<=.8:
			get_node("AnimatedSprite2D").visible=false
		if disappear_timer<=0:
			queue_free()

func _get_angle_to_player():
	if player != null:
		return global_position.angle_to_point(player.global_position)

func _on_area_entered(area):
	if area.is_in_group("Arrow"):
		if area.type == "Multi" or area.type == "MultiChild":
			_die()
	if area.is_in_group("Bow"):
		if player.parrying:
			print("Parried!")
			_on_parry()
	if area.is_in_group("Player"):
		print("Hit Player!")
		_die()
	if area.is_in_group("Ground"):
		_die()

func _on_body_entered(body):
	if body.is_in_group("Arrow"):
		if body.type == "Multi" or body.type == "MultiChild":
			_die()
	if body.is_in_group("Player") and !parried:
		player._take_damage(1)
		_die()
		print("Hit Player!")
	if body.is_in_group("Enemy"):
		if parried:
			body._damage("Orb", 1)
			_die()
	if body.is_in_group("Ground"):
		_die()

func _die():
	marked_for_disappear=true
	if get_node("ParticleCollide") != null and get_node("ParticleTrail") != null:
		get_node("ParticleCollide").emitting=true
		get_node("ParticleTrail").emitting=false

func _on_parry():
	homing = false
	if fixTurn==true:
		vel = speed.rotated(global_position.angle_to_point(Vector2(get_global_mouse_position().x,get_global_mouse_position().y)))
	else:
		vel = -speed.rotated(global_position.angle_to_point(Vector2(get_global_mouse_position().x,get_global_mouse_position().y)))
	
	
	parried = true

