extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const ACCEL = 25.0
const FRICTION = 25.0

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
	direction = 0

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move_left", "move_right")
	
	_aim()
	
	if Input.is_action_just_pressed("left_click"):
		_shoot()

func _physics_process(delta):
	#Lateral Movement
	if direction != 0:
		_accelerate(direction)
	else:
		_friction()
	
	#Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump()
	
	# Add the gravity if not on floor & the player isn't wall sliding
	if not is_on_floor() and not wall_sliding:
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
	#velocity = velocity.move_toward(Vector2(SPEED * dir, velocity.y), ACCEL)
	if (velocity.x + ACCEL * dir) < -SPEED or (velocity.x + ACCEL * dir) > SPEED:
		velocity.x = SPEED * dir
	else:
		velocity.x += ACCEL * dir

func _friction():
	#Add friction to the player
	#velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	if (velocity.x > 0 and (velocity.x - FRICTION) < 0) or (velocity.x < 0 and (velocity.x + FRICTION) > 0):
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= FRICTION
	elif velocity.x < 0:
		velocity.x += FRICTION

func _gravity(delta):
	#Apply gravity
	velocity.y += gravity * delta

func _jump():
	#Jump
	velocity.y = JUMP_VELOCITY
	
	#CREATE VARIABLE HEIGHT JUMP
	print(get_parent().velocity.y)
func _wallslide(delta):
	#Apply wall slide physics
	velocity.y += 1000 * delta
	max_fall_speed = 30
	wall_sliding = true

func _walljump():
	#Wall jump
	velocity.y = JUMP_VELOCITY
	velocity.x = -direction*SPEED/2

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
