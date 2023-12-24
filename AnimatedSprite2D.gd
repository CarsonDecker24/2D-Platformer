extends AnimatedSprite2D

var current = "idle"
var frameHolder=0
var facing = "right"
var fallTest= 0.00
var animationTimer= 0 
var holdingArm
var walkingLoop=false
var walkframe=0
var offSet = 0
var wallSlideCheck = false

@onready var parent = get_parent()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if current == "idle":
		_idle()
	
	elif current== "playThenWind":
		_playThenWind()
	
	if fallTest-global_position.y<0 and not fallTest-global_position.y<-10:
		_on_falling()
	
	if current == "fallslowRight" and get_parent().is_on_floor()==true:
		_on_landing_while_idle()
	
	if current =="fallRight" and get_parent().is_on_floor()==true :
		_on_landing_while_idle()
		
	
	#if the player is WALL SLIDING
	if get_parent().wall_sliding==true and not (Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left")):
		_on_wallslide()
	
	if current == "windupRightWalk":
		_windup_walk()
	
	if current == "walkingRight":
		_walking()
	
	if current == "skidThenIdle":
		_skid_ThenIdle()
	
	if current == "playThenIdle" and is_playing()==false:
		current = "idle"
		play("idle")
	
	if current == "skidRight":
		_skid_process()
	
	if current == "turnLeftSkid":
		_turn_around_skid()
	
	if current == "sliding":
		_sliding_low()
	
	fallTest = global_position.y


func _quickturn():
	
	#if they are FACING RIGHT, then TURN LEFT
	if facing == "right":
		flip_h = true
		facing = "left"
	
	#if they are FACING LEFT, then TURN RIGHT
	elif facing == "left":
		flip_h = false
		facing = "right"

func _idle():
	#if they are FACING LEFT and start to MOVE LEFT=============================================
	if Input.is_action_pressed("move_left") and facing == "left":
		current = "windupRightWalk"
		play("windupRightWalk")
	
	#if they are FACING RIGHT and start to MOVE RIGHT===========================================
	elif Input.is_action_pressed("move_right") and facing == "right":
		current = "windupRightWalk"
		play("windupRightWalk")
		
	
	#if they are FACING LEFT and start to MOVE RIGHT============================================
	elif Input.is_action_pressed("move_right") and facing=="left":
		_quickturn()
		current="playThenWind"
		play("turnIdle")
		
	
	#if they are FACING RIGHT and start to MOVE LEFT============================================
	elif Input.is_action_pressed("move_left") and facing=="right":
		current = "playThenWind"
		_quickturn()
		play("turnIdle")
		
	
	#if they JUMP ==============================================================================
	elif Input.is_action_pressed("jump"):
		current = "jumpIdleRight"
		play("jumpIdleRight")

func _playThenWind():
	if is_playing()==false:
		current="windupRightWalk"
		play("windupRightWalk")
	if Input.is_action_just_pressed("jump"):
		_quickturn()
		current="walkRightJump"
		play("jumpWalkRightUp")

func _on_falling():
	if current == "jumpIdleRight":
		current = "fallslowRight" 
		play("slowFallRight")
	elif (current=="walkRightJump") or (current =="walkingRight" and not get_parent().is_on_floor()):
		current = "fallRight"
		play("walkRightFall")

func _on_landing_while_idle():
	#if the PLAYER IS ON THE FLOOR, go back to the IDLE STATE
	current = "idle"
	play("idle")

func _on_landing_while_walking():
	current="walkingRight"
	play("walkingRight")

func _on_wallslide():
	#this TURNS THE PLAYER AROUND so they FACE against THE WALl=================================
		if get_parent().wall_sliding==true and Input.is_action_pressed("jump"):
			if wallSlideCheck == false:
				play("wallJump")
				wallSlideCheck=true
		elif ((Input.is_action_pressed("move_left") and facing == "right") or (Input.is_action_pressed("move_right") and facing == "left")) and wallSlideCheck==true:
			_quickturn()
		else:
			play("wallDrag")
			wallSlideCheck=false
		
		#WALL JUMP CHECK============================================================================
		

func _windup_walk():
	if facing == "right":
		#if the PLAYER stops MOVING RIGHT before the RIGHT WALK CYCLE plays=========================
		if not Input.is_action_pressed("move_right"):
			current = "playThenIdle"
			frameHolder = frame
			play_backwards("windupRightWalk")
			set_frame_and_progress(frame,0.00)
		
		#if the WINDUP ANIMATION is DONE, then START the WALKCYCLE==================================
		elif Input.is_action_pressed("move_right") and is_playing()==false:
			current = "walkingRight"
			play("walkingRight")
		
		#if the PLAYER starts to MOVE LEFT instead of MOVING RIGHT==================================
		elif Input.is_action_just_pressed("move_left"):
			current = "skidRight"
			play("skidGoingRight")
		
		#if the PLAYER stops MOVING before the WALKING CYCLE starts=================================
		elif is_playing() == false and not Input.is_action_pressed("move_right"):
			current = "playThenIdle"
			frameHolder = frame
			play_backwards("windupRightWalk")
			set_frame_and_progress(frame,0.00)
		
		#if the PLAYER JUMPS========================================================================
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")
			fallTest = global_position.y
	else:
		if not Input.is_action_pressed("move_left"):
			current = "playThenIdle"
			frameHolder=frame
			play_backwards("windupRightWalk")
			set_frame_and_progress((frame),0.00)
		elif Input.is_action_pressed("move_left") and is_playing()==false:
			current = "walkingRight"
			play("walkingRight")
		elif Input.is_action_just_pressed("move_right"):
			current = "skidRight"
			play("skidGoingRight")
		elif is_playing()==false and not Input.is_action_pressed("move_left"):
			current = "playThenIdle"
			frameHolder=frame
			play_backwards("windupRightWalk")
			set_frame_and_progress((frame),0.00)
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")

func _walking():
	if facing=="right":
		#if they CHANGE DIRECTIONS, then SKID=======================================================
		if Input.is_action_just_pressed("move_left"):
			current= "skidRight"
			play("skidRight")
		
		#if the PLAYER STOPS WALKING RIGHT==========================================================
		elif not Input.is_action_pressed("move_right"):
			current = "skidThenIdle" 
			play("unwindRightWalk")
			
		
		#if they JUMP===============================================================================
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")
		
		if Input.is_action_pressed("move_down") and get_parent().sliding==true:
			current = "sliding"
			play("slide")
	else:
		if Input.is_action_just_pressed("move_right"):
			current = "skidRight"
			play("skidRight")
		elif not Input.is_action_pressed("move_left"):
			current = "skidThenIdle" 
			play("unwindRightWalk")
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")
		if Input.is_action_pressed("move_down") and get_parent().sliding==true:
			current = "sliding"
			play("slide")

func _sliding_low():
	if is_playing()==false:
		play("slide_done")
	if not Input.is_action_pressed("move_down"):
		play_backwards("slide")
		set_frame_and_progress(10,0.00)
		current="windupRightWalk"
		print("what")


func _skid_ThenIdle():
	if facing == "right":
		if Input.is_action_pressed("move_left"):
			current = "turnLeftSkid"
			play("turnLeftSkid")
			
		elif is_playing()==false:
			current = "idle"
			play("idle")
	else:
		if Input.is_action_pressed("move_right"):
			current = "turnLeftSkid"
			play("turnLeftSkid")
		elif is_playing() == false:
			current = "idle"
			play("idle")
		if Input.is_action_just_pressed("jump"):
				current="walkRightJump"
				play("jumpWalkRightUp")

func _skid_process():
	if facing=="right":
		if get_parent().activemovespeed>0:
			play("skidingRight")
		elif get_parent().activemovespeed<=0:
			current = "turnLeftSkid"
			play("turnLeftSkid")
	else:
		if get_parent().activemovespeed<0:
			play("skidingRight")
		elif get_parent().activemovespeed>=0:
			current = "turnLeftSkid"
			play("turnLeftSkid")

func _turn_around_skid():
	if is_playing() == false:
		current="walkingRight"
		_quickturn()
		play("walkingRight")
	if Input.is_action_just_pressed("jump"):
			_quickturn()
			current="walkRightJump"
			play("jumpWalkRightUp")

func _on_animation_changed():
	if facing=="right":
		if current=="idle":
			#idle right should be -6, left should be 0.
			parent._pivPos(-6,0)
			walkingLoop=false
			walkframe=0
		if current=="windupRightWalk" or current == "unwindRightWalk":
			parent._pivPos(-4,1)
			walkingLoop=false
			walkframe=0
		if current=="walkingRight":
			parent._pivPos(-3,0)
			walkingLoop=true
			walkframe=0
	elif facing == "left":
		if current=="idle":
			#idle right should be -6, left should be 0.
			parent._pivPos(-2,0)
			walkingLoop=false
			walkframe=0
		if current=="windupRightWalk" or current == "unwindRightWalk":
			parent._pivPos(-4,1)
			walkingLoop=false
			walkframe=0
		if current=="walkingRight":
			parent._pivPos(-5,0)
			walkingLoop=true
			walkframe=0

func _on_frame_changed():
	if current=="walkingRight" or current == "idle":
		if facing=="right":
			if frame==0 or current=="idle":
				parent._pivPos(-3,0)
				parent._armPos(-5,3)
			elif frame ==1:
				parent._pivPos(-4,0)
				parent._armPos(-4,4)
			elif frame == 2:
				parent._pivPos(-5,1)
				parent._armPos(-3,5)
			elif frame==3 :
				parent._pivPos(-6,1)
				parent._armPos(-2,4)
			elif frame==4:
				parent._pivPos(-7,3)
				parent._armPos(-1,3)
			elif frame==5:
				parent._pivPos(-6,1)
				parent._armPos(-2,4)
			elif frame==6:
				parent._pivPos(-5,1)
				parent._armPos(-3,4)
			else:
				parent._pivPos(-4,0)
				parent._armPos(-4,4)
			
		else:
			if frame==4:
				parent._pivPos(-1,3)
				parent._armPos(-8,3)
			elif frame ==5:
				parent._pivPos(-2,2)
				parent._armPos(-7,4)
			elif frame==6:
				parent._pivPos(-3,2)
				parent._armPos(-6,5)
			elif frame==7 :
				parent._pivPos(-4,1)
				parent._armPos(-5,4)
			elif frame==0 or current=="idle":
				parent._pivPos(-5,1)
				parent._armPos(-4,3)
			elif frame==1:
				parent._pivPos(-4,1)
				parent._armPos(-5,4)
			elif frame==2:
				parent._pivPos(-3,2)
				parent._armPos(-6,4)
			elif frame==3:
				parent._pivPos(-2,2)
				parent._armPos(-7,4)
	pass # Replace with function body.
