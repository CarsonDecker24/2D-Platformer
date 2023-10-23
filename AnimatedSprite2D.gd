extends AnimatedSprite2D

var current = "idle"
var frameHolder=0
var facing = "right"
var fallTest= 0.00
var animationTimer= 0 
var holdingArm

#@onready var holdingArmNode = get_node("PivotHoldingArm")

# Called when the node enters the scene tree for the first time.
func _ready():
	#holdingArm = get_node("PivotHoldingArm")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	#IDLE STATE=====================================================================================
	if current == "idle":
		
		#if they are FACING LEFT and start to MOVE LEFT=============================================
		if Input.is_action_pressed("move_left") and facing == "left":
			current = "windupRightWalk"
			play("windupRightWalk")
		
		
		#if they are FACING RIGHT and start to MOVE RIGHT===========================================
		elif Input.is_action_pressed("move_right") and facing == "right":
			current = "windupRightWalk"
			play("windupRightWalk")
			
		
		#if they are FACING LEFT and start to MOVE RIGHT===========================================
		elif Input.is_action_pressed("move_right") and facing=="left":
			_quickturn()
			play("turnIdle")
			current="playThenWind"
			
		
		#if they are FACING RIGHT and start to MOVE LEFT============================================
		elif Input.is_action_pressed("move_left") and facing=="right":
			_quickturn()
			play("turnIdle")
			current = "playThenWind"
	
		
		#if they JUMP
		elif Input.is_action_pressed("jump"):
			current = "jumpIdleRight"
			play("jumpIdleRight")
			
	
	
	#USED TO FINISH THE CURRENT ANIMATION, THEN START WALKING
	elif current== "playThenWind" and is_playing()==false:
		current="windupRightWalk"
		play("windupRightWalk")
	
		
	if fallTest-global_position.y<0 and not fallTest-global_position.y<-10:
		if current == "jumpIdleRight":
			current = "fallslowRight" 
			play("slowFallRight")
		if current=="walkRightJump":
			current = "fallRight"
			play("walkRightFall")
			
	
	if get_parent().wall_sliding==true and not (Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left")):
		if (Input.is_action_pressed("move_left") and facing == "right") or (Input.is_action_pressed("move_right") and facing == "left"):
			_quickturn()
		play("wallDrag")
		
		if get_parent().wall_sliding==true and Input.is_action_just_pressed("jump"):
			play("wallJump")
			_quickturn()
	
	#JUMPING UP STATE==============================================================================
	if current == "jumpIdleRight":
		
		#if the player IS FALLING use the FALLING ANIMATION FRAME
		if fallTest-global_position.y<0 and not fallTest-global_position.y<-20:
			current = "fallslowRight" 
			play("slowFallRight")
		
		#reset the fallTest variable
		fallTest = global_position.y
		
	
	
	#FALLING STATE================================================================================
	if current == "fallslowRight":
		
		#if the PLAYER IS ON THE FLOOR, go back to the IDLE STATE
		if get_parent().is_on_floor()==true:
			play("idle")
			current = "idle"
	#FALLING+WALKING STATE========================================================================
	if current =="fallRight" and get_parent().is_on_floor()==true :
		play("walkingRight")
		current="walkingRight"
	
	
	
	#there are specific  functions for whether or not the player is facing left or right===========
	if facing == "right":
		_facingRight()
	else:
		_facingLeft()
	fallTest = global_position.y

#this function FLIPS the PLAYER====================================================================
func _quickturn():
	
	#if they are FACING RIGHT, then TURN LEFT
		if facing == "right":
			flip_h = true
			facing = "left"
			
			
		
		#if they are FACING LEFT, then TURN RIGHT
		elif facing == "left":
			flip_h = false
			facing = "right"


#this function runs when the PLAYER is FACING RIGHT
func _facingRight():
	
	#WINDUP TO THE WALK STATE ======================================================================
	if current == "windupRightWalk":
		
		
		#if the PLAYER stops MOVING RIGHT before the RIGHT WALK CYCLE plays=========================
		if not Input.is_action_pressed("move_right"):
			current = "playThenIdle"
			frameHolder = frame
			play_backwards("windupRightWalk")
			set_frame_and_progress(frame,0.00)
		
		#if the WINDUP ANIMATION is DONE, then START the WALKCYCLE==================================
		elif Input.is_action_pressed("move_right") and is_playing()==false:
			play("walkingRight")
			current = "walkingRight"
		
		#if the PLAYER starts to MOVE LEFT instead of MOVING RIGHT=================================
		elif Input.is_action_just_pressed("move_left"):
			play("skidGoingRight")
			current = "skidRight"
		
		#if the PLAYER stops MOVING before the WALKING CYCLE starts================================
		elif is_playing() == false and not Input.is_action_pressed("move_right"):
			current = "playThenIdle"
			frameHolder = frame
			play_backwards("windupRightWalk")
			set_frame_and_progress(frame,0.00)
		
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")
			fallTest = global_position.y
	
	
	#if the player is walking right=================================================================
	elif current == "walkingRight":
		if Input.is_action_just_pressed("move_left"):
			current= "skidRight"
			play("skidRight")
		elif not Input.is_action_pressed("move_right"):
			play("unwindRightWalk")
			current = "skidThenIdle" 
			
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")
		
	
	if current == "skidThenIdle":
		if Input.is_action_pressed("move_left"):
			play("turnLeftSkid")
			current = "turnLeftSkid"
		elif is_playing()==false:
			current = "idle"
			play("idle")
	
	#if the player is stopping during the starting to walk animation===============================
	elif current == "playThenIdle" and is_playing()==false:
			play("idle")
			current = "idle"
	
	#if the player is skidding to the right========================================================
	elif current == "skidRight":
		if get_parent().activemovespeed>0:
			play("skidingRight")
		elif get_parent().activemovespeed<=0:
			play("turnLeftSkid")
			current = "turnLeftSkid"
		
	
	elif current == "turnLeftSkid":
		if is_playing() == false:
			_quickturn()
			play("walkingRight")
			current="walkingRight"
		if Input.is_action_just_pressed("jump"):
				current="walkRightJump"
				play("jumpWalkRightUp")
	
	

func _facingLeft():
	if current == "windupRightWalk":
			if not Input.is_action_pressed("move_left"):
				current = "playThenIdle"
				frameHolder=frame
				play_backwards("windupRightWalk")
				set_frame_and_progress((frame),0.00)
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
			if Input.is_action_just_pressed("jump"):
				current="walkRightJump"
				play("jumpWalkRightUp")
			
	
	#if the player is walking right=====================================================
	elif current == "walkingRight" :
		if Input.is_action_just_pressed("move_right"):
			current = "skidRight"
			play("skidRight")
		elif not Input.is_action_pressed("move_left"):
			play("unwindRightWalk")
			current = "skidThenIdle" 
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")
	
	
	if current == "skidThenIdle":
		if Input.is_action_pressed("move_right"):
			play("turnLeftSkid")
			current = "turnLeftSkid"
		elif is_playing() == false:
			current = "idle"
			play("idle")
		if Input.is_action_just_pressed("jump"):
				current="walkRightJump"
				play("jumpWalkRightUp")
	
	
	#if the player is stopping during the starting to walk animation=========================================
	elif current == "playThenIdle" and is_playing()==false:
			play("idle")
			current = "idle"
	
	#if the player is skidding to the right=====================================================
	elif current == "skidRight":
		if get_parent().activemovespeed<0:
			play("skidingRight")
		elif get_parent().activemovespeed>=0:
			play("turnLeftSkid")
			current = "turnLeftSkid"
		
	
	elif current == "turnLeftSkid":
		if is_playing() == false:
			_quickturn()
			play("walkingRight")
			current="walkingRight"
		if Input.is_action_just_pressed("jump"):
				current="walkRightJump"
				play("jumpWalkRightUp")
