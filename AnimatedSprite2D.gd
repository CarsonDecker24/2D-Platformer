extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var current = "idle"
var frameHolder=0
var facing = "right"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#makes the player turn around if they where facing the other way before
	if current == "idle":
		if Input.is_action_pressed("move_left") and facing == "left":
			current = "windupRightWalk"
			play("windupRightWalk")
		if Input.is_action_pressed("move_right") and facing == "right":
			current = "windupRightWalk"
			play("windupRightWalk")
		elif Input.is_action_pressed("move_right") and facing=="left":
			_quickturn()
			play("turnIdle")
			current="playThenWind"
		elif Input.is_action_pressed("move_left") and facing=="right":
			_quickturn()
			play("turnIdle")
			current = "playThenWind"
	
	elif current== "playThenWind" and is_playing()==false:
		current="windupRightWalk"
		play("windupRightWalk")
		
	
	
	if facing=="right":
		_facingRight()
	else:
		_facingLeft()
	
	

func _quickturn():
	#flips the player
		if facing=="right":
			flip_h=true
			facing="left"
			
		elif facing=="left":
			flip_h=false
			facing="right"

func _facingRight():
	if current == "windupRightWalk":
			if not Input.is_action_pressed("move_right"):
				current = "playThenIdle"
				frameHolder=frame
				play_backwards("windupRightWalk")
				set_frame_and_progress(frame,0.00)
			elif Input.is_action_pressed("move_right") and is_playing()==false:
				play("walkingRight")
				current = "walkingRight"
			elif Input.is_action_just_pressed("move_left"):
				play("skidGoingRight")
				current = "skidRight"
			elif is_playing()==false and not Input.is_action_pressed("move_right"):
				current = "playThenIdle"
				frameHolder=frame
				play_backwards("windupRightWalk")
				set_frame_and_progress(frame,0.00)
	
	#if the player is walking right=====================================================
	elif current == "walkingRight" :
		if Input.is_action_just_pressed("move_left"):
			current= "skidRight"
			play("skidRight")
		elif not Input.is_action_pressed("move_right"):
			play("windupRightWalk")
			current = "windupRightWalk"
		elif Input.is_action_just_pressed("shift"):
			#play windupRightRun
			#current = "windupRightRun"
			print("play run windup")
	
	#if the player is stopping during the starting to walk animation=========================================
	elif current=="playThenIdle" and is_playing()==false:
			play("idle")
			current = "idle"
	
	#if the player is skidding to the right=====================================================
	elif current=="skidRight":
		if get_parent().activemovespeed>0:
			play("skidingRight")
		elif get_parent().activemovespeed<=0:
			play("turnLeftSkid")
			current = "turnLeftSkid"
		
	
	elif current == "turnLeftSkid":
		if is_playing()==false:
			_quickturn()
			play("walkingRight")
			current="walkingRight"
			
	
	

func _facingLeft():
	if current == "windupRightWalk":
			if not Input.is_action_pressed("move_left"):
				current = "playThenIdle"
				frameHolder=frame
				play_backwards("windupRightWalk")
				set_frame_and_progress((frame),0.00)
				print(frame)
			elif Input.is_action_pressed("move_left") and is_playing()==false:
				play("walkingRight")
				current = "walkingRight"
			elif Input.is_action_just_pressed("move_right"):
				play("skidGoingRight")
				current = "skidRight"
			elif is_playing()==false and not Input.is_action_pressed("move_left"):
				current = "playThenIdle"
				frameHolder=frame
				play_backwards("windupRightWalk")
				set_frame_and_progress((frame),0.00)
				
	
	#if the player is walking right=====================================================
	elif current == "walkingRight" :
		if Input.is_action_just_pressed("move_right"):
			current= "skidRight"
			play("skidRight")
		elif not Input.is_action_pressed("move_left"):
			play("windupRightWalk")
			current = "windupRightWalk"
		elif Input.is_action_just_pressed("shift"):
			#play windupRightRun
			#current = "windupRightRun"
			print("play run windup")
	
	#if the player is stopping during the starting to walk animation=========================================
	elif current=="playThenIdle" and is_playing()==false:
			play("idle")
			current = "idle"
	
	#if the player is skidding to the right=====================================================
	elif current=="skidRight":
		if get_parent().activemovespeed<0:
			play("skidingRight")
		elif get_parent().activemovespeed>=0:
			play("turnLeftSkid")
			current = "turnLeftSkid"
		
	
	elif current == "turnLeftSkid":
		if is_playing()==false:
			_quickturn()
			play("walkingRight")
			current="walkingRight"


