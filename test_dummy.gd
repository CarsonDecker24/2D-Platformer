extends CharacterBody2D
var player
var hp = 5
var is_dead = false
var personality = "neutral"
var player_spotted = false
var player_distance=0
var player_angle=0
var player_side_right=true
var animation_frame=0
var animation_state = "idle"
var sees_player = false
var shoot_cooldown=1
var debuff_cooldown=1
var fire_rate_mod=1
var speed_mod=1
var walking = "walking holster"
var idle = "idle holster"
const SPEED =60
const FIRE_RATE=1
const orbPath = preload("res://orb.tscn")
@onready var animator = get_node("dummyPlayer")
@onready var target_ray = get_node("TargetRay")
func _ready():
	get_node("ice_particles").set_deferred("emitting", false)

@warning_ignore("unused_parameter")
func _physics_process(delta):
	move_and_slide()

func _spot_player(body):
	if player_spotted == false:
		player = body
		player_spotted = true
		target_ray.enabled = true

@warning_ignore("unused_parameter")
func _process(delta):
	_check_rays()
	
	#resets general stats when debufs are over
	if debuff_cooldown<0:
		speed_mod=1
		fire_rate_mod=1
		get_node("ice_particles").set_deferred("emitting", false)
	shoot_cooldown-=delta
	debuff_cooldown-=delta
	
	#gets the distance between this enemy and the player

	
	if player_spotted==true:
		#this line gets the players distance from the dummy
		player_distance=sqrt((player.global_position.y-global_position.y) * (player.global_position.y-global_position.y) + ((player.global_position.x-global_position.x) * (player.global_position.x-global_position.x)))
		
		#loose track of player
		if player_distance>300:
			print("over 300")
			player_spotted=false
		
		#this gets the angle relative to the player for aiming sake
		_get_angle_to_player()
		
		#print(player.global_position)
		target_ray.target_position = (player.global_position - target_ray.global_position) * 1000
		
		#Set ray to point at target
		if not target_ray.get_collider() == null and target_ray.get_collider().is_in_group("Player"):
			sees_player = true
		else:
			sees_player = false
		
		print(sees_player)
		if sees_player and shoot_cooldown<0:
			_shoot_orb()
			shoot_cooldown=FIRE_RATE/fire_rate_mod
		
		#this flips the dummy to face the placer once the player has been spotted 
		if player.global_position.x>global_position.x:
			animator.flip_h=false
			player_side_right=true
		else:
			animator.flip_h=true
			player_side_right=false
		
		#this makes the dummy keep optimal distance with the player
		#minimise this to hide animation related things
		if player_distance>100:
			
			if player_side_right==true:
				velocity.x=SPEED*speed_mod
				if animation_state=="walking" and animator.is_playing()==false:
					animator.play(walking)
					animation_state="walking"
				else:
					animator.play(walking)
					animation_state="walking"
			else:
				velocity.x=-SPEED*speed_mod
				animator.play(walking)
				if animation_state=="walking" and animator.is_playing()==false:
					animator.play(walking)
					animation_state="walking"
				else:
					animator.play(walking)
					animation_state="walking"
		
		elif player_distance<40:
			if player_side_right==true:
				velocity.x=-SPEED*speed_mod
				if animation_state=="walkingBack" and animator.is_playing()==false:
					animator.play_backwards(walking)
					animation_state="walkingBack"
				else:
					animator.play_backwards(walking)
					animation_state="walkingBack"
			else:
				velocity.x=SPEED*speed_mod
				if animation_state=="walkingBack" and animator.is_playing()==false:
					animator.play_backwards(walking)
					animation_state="walkingBack"
				else:
					animator.play_backwards(walking)
					animation_state="walkingBack"
		#and if they are in the optimal distance obviously they dont need to move
		else:
			velocity.x=0
			animator.play(idle)
	else:
		velocity.x=0
		animator.play(idle)
	_wizardAim()
	

func _wizardAim():
	if player!=null and sees_player==true:
		if player_side_right==true:
			
			if abs(rad_to_deg(_get_angle_to_player()))>270 and abs(rad_to_deg(_get_angle_to_player()))<330:
				walking = "walking down"
				idle = "idle down"
			elif abs(rad_to_deg(_get_angle_to_player()))>330 or abs(rad_to_deg(_get_angle_to_player()))<30:
				walking = "walking level"
				idle = "idle level"
			elif abs(rad_to_deg(_get_angle_to_player()))>30 and  abs(rad_to_deg(_get_angle_to_player()))<60:
				walking = "walking up"
				idle = "idle up" 
			elif abs(rad_to_deg(_get_angle_to_player()))>60 and  abs(rad_to_deg(_get_angle_to_player()))<90:
				walking = "walking upward"
				idle = "idle upward"
		else:
			if abs(rad_to_deg(_get_angle_to_player()))<270 and abs(rad_to_deg(_get_angle_to_player()))>210:
				walking = "walking down"
				idle = "idle down"
			elif abs(rad_to_deg(_get_angle_to_player()))<210 or abs(rad_to_deg(_get_angle_to_player()))>150:
				walking = "walking level"
				idle = "idle level"
			elif abs(rad_to_deg(_get_angle_to_player()))>120 and  abs(rad_to_deg(_get_angle_to_player()))<150:
				walking = "walking up"
				idle = "idle up"
			elif abs(rad_to_deg(_get_angle_to_player()))>60 and  abs(rad_to_deg(_get_angle_to_player()))<90:
				walking = "walking upward"
				idle = "idle upward"
	else:
		idle = "idle holster"
		walking = "walking holster"

func _lower_health(hp_reduction: int):
	hp -= hp_reduction
	print("Remaining HP: " + str(hp))
	if (hp <= 0):
		print("Died!")
		is_dead = true
		queue_free()
	player_spotted=true

#Deal damage, requires arrow type
func _damage(type: String, damage: int):
	if type == "Ice":
		hp -= damage
		debuff_cooldown=3
		speed_mod=.5
		fire_rate_mod=.7
		get_node("ice_particles").set_deferred("emitting", true)
	else:
		hp -= damage
	print("Remaining HP: " + str(hp))
	if (hp <= 0):
		print("Died!")
		is_dead = true
		queue_free()
	
		

func _is_dead():
	return is_dead

func _get_angle_to_player():
	if player != null:
		player_angle=global_position.angle_to_point(player.global_position)
		print(player_angle)
		return global_position.angle_to_point(player.global_position)
		

func _shoot_orb():
	var orb = orbPath.instantiate()
	orb._setup(Vector2(3,0).rotated(_get_angle_to_player()), player, get_meta("homing"))
	add_sibling(orb)
	orb.position = global_position

func _check_rays():
	if get_node("RayMid").get_collider() and not get_node("RayMid").get_collider() == null and get_node("RayMid").get_collider().is_in_group("Player"):
		_spot_player(get_node("RayMid").get_collider())
	if get_node("RayMidDown").get_collider() and not get_node("RayMidDown").get_collider() == null and get_node("RayMidDown").get_collider().is_in_group("Player"):
		_spot_player(get_node("RayMidDown").get_collider())
	if get_node("RayMidUp").get_collider() and not get_node("RayMidUp").get_collider() == null and get_node("RayMidUp").get_collider().is_in_group("Player"):
		_spot_player(get_node("RayMidUp").get_collider())
	if get_node("RayDown").get_collider() and not get_node("RayDown").get_collider() == null and get_node("RayDown").get_collider().is_in_group("Player"):
		_spot_player(get_node("RayDown").get_collider())
	if get_node("RayUp").get_collider() and not get_node("RayUp").get_collider() == null and get_node("RayUp").get_collider().is_in_group("Player"):
		_spot_player(get_node("RayUp").get_collider())
