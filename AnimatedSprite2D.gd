extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var current = "idle"
var frameHolder=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#idle state
	if Input.is_action_just_pressed("move_right") and current == "idle":
		current = "windupRightWalk"
		play("windupRightWalk")
		#set up timer to track the current frame from 0
		
	#inbetween idle and walking, aka windup
	elif current == "windupRightWalk":
			if Input.is_action_just_released("move_right"):
				current = "unwindRightWalk"
				frameHolder=frame
				play_backwards("windupRightWalk")
				set_frame_and_progress((9-frame),0.00)
				$AnimationTimer.start
			elif Input.is_action_pressed("move_right") and is_playing()==false:
				play("walkingRight")
				current = "walkingRight"
			elif Input.is_action_just_pressed("move_left"):
				#play("skidGoingRight")
				current = "skidGoingRight"
	
	#walkingright
	elif current == "walkingRight" :
		if Input.is_action_just_released("move_right"):
			play("unwindRightWalk")
			current = "unwindRightWalk"
		elif Input.is_action_just_pressed("shift"):
			#play windupRightRun
			#current = "windupRightRun"
			print("play run windup")
	
	#walkingright to idle, aka unwinding
	elif current == "unwindRightWalk" and is_playing()==false:
			play("idle")
			current = "idle"
			
			
			
			
	
	pass


func _on_animation_timer_timeout():
	
	pass # Replace with function body.
