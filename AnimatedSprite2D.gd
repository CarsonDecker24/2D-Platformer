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

@onready var parent = get_parent()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(current)
	
	
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
	
	#USED TO FINISH THE CURRENT ANIMATION, THEN START WALKING=======================================
	elif current== "playThenWind":
		if is_playing()==false:
			current="windupRightWalk"
			play("windupRightWalk")
		if Input.is_action_just_pressed("jump"):
			_quickturn()
			current="walkRightJump"
			play("jumpWalkRightUp")
	
	#this runs when the player is FALLING, basically at the HEIGHT OF THEIR JUMP====================
	if fallTest-global_position.y<0 and not fallTest-global_position.y<-10 and not Input.is_action_pressed("ctrl"):
		if current == "jumpIdleRight":
			current = "fallslowRight" 
			play("slowFallRight")
		if current=="walkRightJump":
			current = "fallRight"
			play("walkRightFall")
	
	if ((current == "fallslowRight" or current == "jumpIdleRight" or current == "walkRightJump" or current=="fallRight") and Input.is_action_pressed("ctrl")) or current== "airCrouching" or current == "airCrouched" or current == "unAirCrouching":
		if current =="airCrouching" and is_playing()==false:
			play("airCrouched")
			current == "airCrouched"
		if current!= "fallslowRight" and current != "jumpIdleRight" and current != "walkRightJump":
			current = "airCrouching"
			play("airCrouching")
		if current=="airCrouched" and Input.is_action_just_released("ctrl"):
			play_backwards("airCrouching")
			current == "unAirCrouching"
		if current == "unAirCrouching" and is_playing()==false:
			current ="fallRight"
			play("walkRightFall")
	
	
	#this CHECKS to see if the PLAYER has LANDED yet================================================
	if current == "fallslowRight":
		
		#if the PLAYER IS ON THE FLOOR, go back to the IDLE STATE
		if get_parent().is_on_floor()==true:
			current = "idle"
			play("idle")

	
	#checks to see if the PLAYER has landed, AFTER JUMPING FORWARDS=================================
	if current =="fallRight" and get_parent().is_on_floor()==true :
		current="walkingRight"
		play("walkingRight")
		
	
	#if the player is WALL SLIDING (and they arent holding left and right)==========================
	if get_parent().wall_sliding==true and not (Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left")):
		
		#this TURNS THE PLAYER AROUND so they FACE against THE WALl=================================
		if (Input.is_action_pressed("move_left") and facing == "right") or (Input.is_action_pressed("move_right") and facing == "left"):
			_quickturn()
		play("wallDrag")
		
		#WALL JUMP CHECK============================================================================
		if get_parent().wall_sliding==true and Input.is_action_just_pressed("jump"):
			play("wallJump")
			_quickturn()

	#there are specific  functions for whether or not the player is facing left or right===========
	if facing == "right":
		_facingRight()
	else:
		_facingLeft()
	
	#Resets a variable used to determine if the player is falling.
	fallTest = global_position.y

#this function FLIPS the PLAYER=====================================================================
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
	
	#WINDUP TO THE WALKING STATE ===================================================================
	if current == "windupRightWalk":
		
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
	
	
	#if the player is walking right=================================================================
	elif current == "walkingRight":
		
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
	
	#if the PLAYER is SKIDDING to a HALT============================================================
	if current == "skidThenIdle":
		if Input.is_action_pressed("move_left"):
			current = "turnLeftSkid"
			play("turnLeftSkid")
			
		elif is_playing()==false:
			current = "idle"
			play("idle")
	
	#if the player is stopping during the starting to walk animation===============================
	elif current == "playThenIdle" and is_playing()==false:
			current = "idle"
			play("idle")
			
	
	#if the player is skidding to the right========================================================
	elif current == "skidRight":
		if get_parent().activemovespeed>0:
			play("skidingRight")
		elif get_parent().activemovespeed<=0:
			current = "turnLeftSkid"
			play("turnLeftSkid")
			
		
	
	elif current == "turnLeftSkid":
		if is_playing() == false:
			current="walkingRight"
			_quickturn()
			play("walkingRight")
		if Input.is_action_just_pressed("jump"):
				_quickturn()
				current="walkRightJump"
				play("jumpWalkRightUp")

#and this one runs when the PLAYER is FACING LEFT
func _facingLeft():
	
	if current == "windupRightWalk":
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
			
	
	#if the player is walking right=====================================================
	elif current == "walkingRight" :
		if Input.is_action_just_pressed("move_right"):
			current = "skidRight"
			play("skidRight")
		elif not Input.is_action_pressed("move_left"):
			current = "skidThenIdle" 
			play("unwindRightWalk")
		if Input.is_action_just_pressed("jump"):
			current="walkRightJump"
			play("jumpWalkRightUp")
	
	
	if current == "skidThenIdle":
		if Input.is_action_pressed("move_right"):
			current = "turnLeftSkid"
			play("turnLeftSkid")
		elif is_playing() == false:
			current = "idle"
			play("idle")
		if Input.is_action_just_pressed("jump"):
				current="walkRightJump"
				play("jumpWalkRightUp")
	
	#if the player is stopping during the starting to walk animation=========================================
	elif current == "playThenIdle" and is_playing()==false:
			current = "idle"
			play("idle")
	
	#if the player is skidding to the right=====================================================
	elif current == "skidRight":
		if get_parent().activemovespeed<0:
			play("skidingRight")
		elif get_parent().activemovespeed>=0:
			current = "turnLeftSkid"
			play("turnLeftSkid")
	
	elif current == "turnLeftSkid":
		if is_playing() == false:
			current="walkingRight"
			_quickturn()
			play("walkingRight")
		if Input.is_action_just_pressed("jump"):
				current="walkRightJump"
				_quickturn()
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
	if walkingLoop==true:
		if facing=="right":
			if frame==0:
				parent._pivPos(-3,0)
			elif frame ==1:
				parent._pivPos(-3,-1)
			elif frame>=2 and frame<=4:
				parent._pivPos(-3,-2)
			elif frame==5 :
				parent._pivPos(-3,-1)
			elif frame==6:
				parent._pivPos(-3,0)
			elif frame==7:
				parent._pivPos(-3,1)
		else:
			if frame==0:
				parent._pivPos(-5,1)
			elif frame ==1:
				parent._pivPos(-5,0)
			elif frame>=2 and frame<=4:
				parent._pivPos(-5,-1)
			elif frame==5 :
				parent._pivPos(-5,-0)
			elif frame==6:
				parent._pivPos(-5,1)
			elif frame==7:
				parent._pivPos(-5,2)
	pass # Replace with function body.
