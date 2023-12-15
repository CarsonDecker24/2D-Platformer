extends CharacterBody2D
var player
var hp = 5
var is_dead = false
var state = "neutral"
var player_spotted = false
var player_distance=0
var player_angle=0
var player_side_right=true
var animation_state = "idle"
var sees_player = false
var shoot_cooldown=1
var debuff_cooldown=1
var fire_rate_mod=1
var speed_mod=1
var walking = "walking holster"
var idle = "idle holster"
const SPEED =130
const FIRE_RATE=1
var from_facing
var oiled = false
var wandPos = Vector2(0,0)
const orbPath = preload("res://orb.tscn")
@onready var animator = get_node("dummyPlayer")
@onready var target_ray = get_node("TargetRay")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wandSpin = .3
var WANDTIME = .3
var bouttaShoot = false
var groundCheck
var groundDistance
var ledgeTest=false
var ledgePosition
var distanceToLedge
var platformCheck=false
var jumpInstance=false
var FRICTION = 25

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
	
	_shoot_orb(delta)
	#resets general stats when debufs are over
	if debuff_cooldown<0:
		speed_mod=1
		fire_rate_mod=1
		get_node("ice_particles").set_deferred("emitting", false)
	shoot_cooldown-=delta
	debuff_cooldown-=delta
	
	_gravity(delta)
	
	_player_spotted()
	
	_idle_state()
	
	_wizardAim()
	
	_turn_rays()
	
	_friction()

func _idle_state():
	if state=="neutral":
		pass


func _player_spotted():
	if player_spotted==true:
		#this line gets the players distance from the dummy
		state="sees_player"
		player_distance=sqrt((player.global_position.y-global_position.y) * (player.global_position.y-global_position.y) + ((player.global_position.x-global_position.x) * (player.global_position.x-global_position.x)))
		
		#loose track of player
		if player_distance>300:
			print("over 300")
			player_spotted=false
			state="neutral"
		
		#gets the point where raydown collides with the floor in this case.
		if get_node("RayDown").get_collider() and not get_node("RayDown").get_collider() == null:
			if get_node("RayDown").get_collision_point():
				groundCheck=get_node("RayDown").get_collision_point()
			#groundCheck stores the point of RayDowns last collision
			
			if groundCheck[1]<-46:
				ledgePosition=groundCheck
			#if the collision point of RayDown is lower than the platform TestDummy is standing on, it stores that position as the position of the ledge
			
			if ledgePosition!=null:
				$point.global_position=ledgePosition
			distanceToLedge=abs(global_position.x-ledgePosition.x)
			
			if distanceToLedge<13 and not groundCheck[1]<-46:
				print("theres a platform!")
				if jumpInstance==false and player_distance>150 and is_on_floor():
					velocity.y=-300
					jumpInstance=true
					
				if jumpInstance==false and player_distance<150:
					player_distance=90
					
			elif distanceToLedge<13:
				print("there is no platform")
				platformCheck=false
			print(groundCheck[1])
		
		if jumpInstance==true:
			if $dummyPlayer.flip_h==false:
				velocity.x+=300
				print("changed")
			else:
				velocity.x-=300
				print("changed")
		if is_on_floor()==true:
			jumpInstance=false
			
		
		
		#this gets the angle relative to the player for aiming sake
		_get_angle_to_player()
		
		#print(player.global_position)
		target_ray.target_position = (player.global_position - target_ray.global_position) * 1000
		
		#Set ray to point at target
		if not target_ray.get_collider() == null and target_ray.get_collider().is_in_group("Player"):
			sees_player = true
		else:
			sees_player = false
		
		
		if sees_player and shoot_cooldown<0:
			bouttaShoot=true
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
		if player_distance>100 and is_on_floor():
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
		
		elif player_distance<40 and is_on_floor():
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
			animator.play(idle)
	else:
		animator.play(idle)



func _wizardAim():
	if player!=null and sees_player==true:
		get_node("Wand").self_modulate=Color(1, 1, 1, 1)
		if player_side_right==true:
			get_node("Wand").flip_h=true
			$Wand.offset= Vector2(2.5,-2.17)
			if abs(rad_to_deg(_get_angle_to_player()))>270 and abs(rad_to_deg(_get_angle_to_player()))<330:
				walking = "walking down"
				idle = "idle down"
				wandPos= Vector2(7.5,1.25)
				
			elif abs(rad_to_deg(_get_angle_to_player()))>330 or abs(rad_to_deg(_get_angle_to_player()))<30:
				walking = "walking level"
				idle = "idle level"
				wandPos= Vector2(7.5,-1.25)
			elif abs(rad_to_deg(_get_angle_to_player()))>30 and  abs(rad_to_deg(_get_angle_to_player()))<60:
				walking = "walking up"
				idle = "idle up" 
				wandPos= Vector2(7.5,-5)
			elif abs(rad_to_deg(_get_angle_to_player()))>60 and  abs(rad_to_deg(_get_angle_to_player()))<90:
				walking = "walking upward"
				idle = "idle upward"
				wandPos= Vector2(5,-8.75)
		else:
			$Wand.offset= Vector2(-2.5,-2.17)
			get_node("Wand").flip_h=false
			if abs(rad_to_deg(_get_angle_to_player()))<270 and abs(rad_to_deg(_get_angle_to_player()))>210:
				walking = "walking down"
				idle = "idle down"
				wandPos= Vector2(-7.5,1.25)
			elif abs(rad_to_deg(_get_angle_to_player()))<210 or abs(rad_to_deg(_get_angle_to_player()))>150:
				walking = "walking level"
				idle = "idle level"
				wandPos= Vector2(-7.5,-1.25)
			elif abs(rad_to_deg(_get_angle_to_player()))>120 and  abs(rad_to_deg(_get_angle_to_player()))<150:
				walking = "walking up"
				idle = "idle up"
				wandPos= Vector2(-7.5,-5)
			elif abs(rad_to_deg(_get_angle_to_player()))>60 and  abs(rad_to_deg(_get_angle_to_player()))<90:
				walking = "walking upward"
				idle = "idle upward"
				wandPos= Vector2(-5,-8.75)
	else:
		idle = "idle holster"
		walking = "walking holster"
		get_node("Wand").self_modulate=Color(1, 1, 1, 0)
	if $dummyPlayer.frame==0:
		get_node("Wand").position=Vector2(wandPos.x,wandPos.y)
	else:
		get_node("Wand").position=Vector2(wandPos.x,wandPos.y-1.25)
		
	

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
	elif type == "Fire":
		hp -= damage * 3
		oiled = false
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
		#print(player_angle)
		return global_position.angle_to_point(player.global_position)
		

func _shoot_orb(delta):
	if bouttaShoot==true and wandSpin>0:
		wandSpin-=delta
		get_node("Wand").rotation= (WANDTIME-wandSpin)*20
	
	
	if wandSpin<=0 and bouttaShoot==true:
		var orb = orbPath.instantiate()
		orb._setup(Vector2(200*delta,0).rotated(_get_angle_to_player()), player, get_meta("homing"),player_side_right)
		add_sibling(orb)
		orb.position = $Wand.global_position
		bouttaShoot=false
		wandSpin=WANDTIME
	

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

func _turn_rays():
	if $dummyPlayer.flip_h==false:
		get_node("RayMid").target_position.x=210
		get_node("RayMidDown").target_position.x=205
		get_node("RayMidUp").target_position.x=205
		get_node("RayDown").target_position.x=200
		get_node("RayUp").target_position.x=182.5
	else:
		get_node("RayMid").target_position.x=-210
		get_node("RayMidDown").target_position.x=-205
		get_node("RayMidUp").target_position.x=-205
		get_node("RayDown").target_position.x=-200
		get_node("RayUp").target_position.x=-182.5

func _friction():
	if is_on_floor():
		if (velocity.x > 0 and (velocity.x - FRICTION) < 0) or (velocity.x < 0 and (velocity.x + FRICTION) > 0):
			velocity.x = 0
		elif velocity.x > 0:
			velocity.x -= FRICTION
		elif velocity.x < 0:
			velocity.x += FRICTION

func _gravity(delta):
	#Apply gravity
	velocity.y += gravity * delta
	pass
