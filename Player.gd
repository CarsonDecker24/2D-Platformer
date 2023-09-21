extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const ACCEL = 1.0
const FRICTION = 1.0

const bulletPath = preload("res://bullet.tscn")

var direction
var pivot
var weapon_sprite
var weapon_flipped = false
var mousepoint
var aim_vector
var wall_sliding = false
var facing = 1
var max_fall_speed = -1
var acceleration = 0
var activemovespeed = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pivot = get_node("Pivot")
	weapon_sprite = get_node("Pivot/Sprite2D")

func _process(delta):
	direction = Input.get_axis("move_left", "move_right")
	
	_aim()
	
	if Input.is_action_just_pressed("left_click"):
		_shoot()

func _physics_process(delta):
	

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	
	if direction and activemovespeed<100 and activemovespeed>-100:
		acceleration = direction * SPEED/10
	
	activemovespeed=acceleration + activemovespeed
	if acceleration>0:acceleration= acceleration -SPEED/20
	if acceleration<0: acceleration = acceleration + SPEED/20
	if activemovespeed<0: activemovespeed=activemovespeed+SPEED/20
	if activemovespeed>0: activemovespeed=activemovespeed-SPEED/20
	
	velocity.x=activemovespeed
	
	if direction != 0:
		facing = direction
	
	# Add the gravity.
	if not is_on_floor() and not (is_on_wall_only() and direction != 0):
		_gravity(delta)
		
	if is_on_wall_only() and direction != 0:
		_wallslide(delta)
	else:
		max_fall_speed = 1000
		wall_sliding = false
	
	if wall_sliding and Input.is_action_just_pressed("jump"):
		_walljump()
	
	if velocity.y > max_fall_speed: velocity.y = max_fall_speed
	
	move_and_slide()

func _accelerate(dir):
	#Accelerate in whatever direction the player is wanting to move.
	velocity = velocity.move_toward(SPEED * dir, ACCEL)

func _friction():
	#Add friction to the player
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func _gravity(delta):
	#Apply gravity
	velocity.y += gravity * delta

func _jump():
	#Jump
	velocity.y = JUMP_VELOCITY
	
	#CREATE VARIABLE HEIGHT JUMP

func _wallslide(delta):
	#Apply wall slide physics
	velocity.y += 1000 * delta
	max_fall_speed = 30
	wall_sliding = true

func _walljump():
	#Wall jump
	velocity.y = JUMP_VELOCITY
	activemovespeed = -direction*SPEED/2

func _aim():
	#Aim toward mouse position
	pivot.rotation = get_angle_to(get_global_mouse_position())
	
	#Flip sprite to always be facing upward
	if (pivot.rotation_degrees > 90 or pivot.rotation_degrees < -90) and not weapon_flipped:
		weapon_sprite.scale.y *= -1
		weapon_flipped = true
	elif not (pivot.rotation_degrees > 90 or pivot.rotation_degrees < -90) and weapon_flipped:
		weapon_sprite.scale.y *= -1
		weapon_flipped = false

func _shoot():
	#Creates an instance of the bullet scene, sets inital rotation, and sets velocity to shoot at mouse
	var bullet = bulletPath.instantiate()
	add_sibling(bullet)
	bullet.position = get_node("Pivot/Sprite2D/BulletSpawn").global_position
	bullet.rotation = pivot.rotation
	bullet.set_axis_velocity(Vector2(200,0).rotated(bullet.rotation))
