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

@onready var animator = get_node("AnimatedSprite2D")

func _physics_process(delta):
	move_and_slide()

func _spot_player(body):
	player = body
	player_spotted=true

func _process(delta):
	#print(player_distance)
	
	
	if player_spotted==true:
		
		#this line gets the players distance from the dummy
		player_distance=sqrt((player.global_position.y-global_position.y) * (player.global_position.y-global_position.y) + ((player.global_position.x-global_position.x) * (player.global_position.x-global_position.x)))
		
		#this gets the angle relative to the player for aiming sake
		
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
			else:
				velocity.x=-60
		elif player_distance<40:
			if player_side_right==true:
				velocity.x=-60
			else:
				velocity.x=60
		#and if they are in the optimal distance obviously they dont need to move
		else:
			velocity.x=0
		


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
	if type == "Fire":
		hp -= damage
	print("Remaining HP: " + str(hp))
	if (hp <= 0):
		print("Died!")
		is_dead = true
		queue_free()

func _is_dead():
	return is_dead

func _func_on_body_entered():
	print("youch")


