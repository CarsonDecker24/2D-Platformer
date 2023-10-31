extends CharacterBody2D
var player
var hp = 5
var is_dead = false
var player_angle=0
var personality = "neutral"
var player_spotted = false
var player_distance=0
var player_side_right=true
var animation_frame=0
var animation_state = "idle"

@onready var animator = get_node("dummyPlayer")
@onready var target_ray = get_node("TargetRay")

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
	#print(player_distance)
	_check_rays()
	
	if player_spotted==true:
		
		#this line gets the players distance from the dummy
		player_distance=sqrt((player.global_position.y-global_position.y) * (player.global_position.y-global_position.y) + ((player.global_position.x-global_position.x) * (player.global_position.x-global_position.x)))
		
		#this gets the angle relative to the player for aiming sake
		_get_angle_to_player()
		
		print(player.global_position)
		target_ray.target_position = (player.global_position - target_ray.global_position) * 1000
		
		#Set ray to point at target
		if not target_ray.get_collider() == null and target_ray.get_collider().is_in_group("Player"):
			print("Sees Player")
		else:
			print("Does not see Player")
		
		#this flips the dummy to face the placer once the player has been spotted 
		if player.global_position.x>global_position.x:
			animator.flip_h=false
			player_side_right=true
		else:
			animator.flip_h=true
			player_side_right=false
		
		#this makes the dummy keep optimal distance with the player
		if player_distance>100:
			
			if player_side_right==true:
				velocity.x=60
				if animation_state=="walking" and animator.is_playing()==false:
					animator.play("walking")
					animation_state=="walking"
					print("crap")
				else:
					animator.play("walking")
					animation_state=="walking"
			else:
				velocity.x=-60
				animator.play("walking")
				if animation_state=="walking" and animator.is_playing()==false:
					animator.play("walking")
					animation_state=="walking"
				else:
					animator.play("walking")
					animation_state=="walking"
		
		elif player_distance<40:
			if player_side_right==true:
				velocity.x=-60
				if animation_state=="walkingBack" and animator.is_playing()==false:
					animator.play_backwards("walking")
					animation_state=="walkingBack"
				else:
					animator.play_backwards("walking")
					animation_state=="walkingBack"
			else:
				velocity.x=60
				if animation_state=="walkingBack" and animator.is_playing()==false:
					animator.play_backwards("walking")
					animation_state=="walkingBack"
				else:
					animator.play_backwards("walking")
					animation_state=="walkingBack"
		#and if they are in the optimal distance obviously they dont need to move
		else:
			velocity.x=0
			animator.play("idle")
		


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
	print("Remaining HP: " + str(hp))
	if (hp <= 0):
		print("Died!")
		is_dead = true
		queue_free()

func _is_dead():
	return is_dead

func _get_angle_to_player():
	if player != null:
		return rad_to_deg(global_position.angle_to_point(player.global_position))

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
