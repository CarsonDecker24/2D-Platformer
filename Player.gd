extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -300.0
const ACCEL = 25.0

const DEFAULTARROWSPEED = 1.1
var arrowPath = load("res://new_arrow.tscn")
var throwablePath = load("res://throwable.tscn")
const FIRECOOLDOWN = .15#.4

var FRICTION = 25.0
var AIR_FRICTION = 10.0
var direction
var pivot
var weapon_sprite
var weapon_flipped = false
var wall_sliding = false
var facing = 1
var max_fall_speed = -1
var activemovespeed = 0
var aiming = false
var charge_amount = 0
var fire_cooldown = FIRECOOLDOWN
var fire_state = "not"
var drawing = false
var arrow_hud_slot = 1
var arrow_hud_scroll_direction =1
var slots = ["Fire", "Electricity", "Ice"]
var throwable = "Brick"
var arrow_count=0
var wallJumpNerf = 0
var GrapplePivot
var dashTime=0
var shiftSlot= "Air"
var shift_use_time=1
var shift_cooldown=1
var health = 3
var parrying = false
var parryTime = 0
var parryCooldown = 0
var bowTurning=true
var invincibilityFrames =0
var oiled = false
var sliding = false
const INVINCIBILITYTIME = .2
var wallJumpCoyote = 0
var hudPosition
var hudSpeed = 0
var hudUp = "isUp"
var hudSlow = false
var collect = false
var shift_used = false
var meleeCollideArray
var inBulletTime = false
var bulletTimeleft = .5
var wet = false
var wetTimer=0
@onready var animPlayer = get_node("PivotHoldingArm/HoldingArmAnimation")
@onready var arrowHud = get_node("Camera/SelectedArrowHud")
@onready var piv = get_node("PivotHoldingArm")
var thingyCount=0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#woowee
func _ready():
	pivot = get_node("PivotHoldingArm")
	#GrapplePivot = get_node("PivotHoldingArm/HoldingArmAnimation/GrappleRope")
	weapon_sprite = get_node("PivotHoldingArm/HoldingArmAnimation")
	direction = 0
	Engine.time_scale = 1
	inBulletTime = false
	_refreshArrowHud()

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move_left", "move_right")
	
	#Variable for which direction the player is facing
	if direction != 0:
		facing = direction
	#Aim functions
	_aim(delta)
	
	#Shooting functions
	_shoot_check(delta)
	
	#Changing Arrows
	_arrow_hud()
	
	dashTime-=delta
	shift_cooldown-=delta
	shift_use_time-=delta
	invincibilityFrames-=delta
	if shift_use_time>0:
		animPlayer.play("4air_quickfire")
		animPlayer._shootAnim(fire_state)
	if shift_use_time<0 and fire_state=="air-row":
		fire_state="not"
	if dashTime<=0:
		FRICTION=25
	else:
		FRICTION=3
	if invincibilityFrames>0:
		$PlayerBodyAnimation.self_modulate=Color(1, 1, 1, .8)
	else:
		$PlayerBodyAnimation.self_modulate=Color(1, 1, 1, 1)
	#get_node("Node2D/TextureRect").
	
	if Input.is_action_pressed("move_down") and is_on_floor() and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and $PlayerBodyAnimation.current=="walkingRight":
		_slide(direction)
	else:
		_unSlide()
	
	if sliding==true:
		$"slide particles".emitting=true
		
	else:
		$"slide particles".emitting=false
	
	if not inBulletTime:
		bulletTimeleft += delta * .5
	else:
		bulletTimeleft -= delta
		if bulletTimeleft <= 0:
			bulletTimeleft = -1
	
	if Input.is_action_just_pressed("q") and throwable == "":
		_pick_up_throwable()
	elif Input.is_action_just_pressed("q"):
		_throw()
	
	if Input.is_action_just_pressed("space") and not bulletTimeleft <= 0:
		Engine.time_scale = .3
		inBulletTime = true
	
	if Input.is_action_just_released("space") or bulletTimeleft <= 0:
		Engine.time_scale = 1
		inBulletTime = false
	
	if Input.is_action_just_pressed("i") and hudUp == "isDown":
		hudUp = "up"
	elif Input.is_action_just_pressed("i") and hudUp == "isUp":
		hudUp = "down"
	_hudUp()
	
	if wet==true:
		_wet(delta)

func _physics_process(delta):
	#Lateral Movement
	if direction != 0 and sliding==false:
		_accelerate(direction)
	else:
		_friction()
	
	#Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump()
	
	
	
	# Add the gravity if not on floor & the player isn't wall sliding
	if not is_on_floor() and not wall_sliding:
		_gravity(delta)
		
	if is_on_wall_only():
		_wallslide(delta)
	else:
		max_fall_speed = 1000
		if wall_sliding:
			wall_sliding = false
			wallJumpCoyote = .1
	
	if not wall_sliding:
		wallJumpCoyote -= delta
	
	if (wall_sliding or wallJumpCoyote > 0) and Input.is_action_just_pressed("jump"):
		_walljump()
	
	if velocity.y > max_fall_speed: velocity.y = max_fall_speed
	
	
	if wallJumpNerf>0:
		wallJumpNerf-=delta
	
	if Input.is_action_just_pressed("shift"):
		if shiftSlot=="Air" and shift_cooldown<=0 and get_node("Camera/shiftBar").is_playing()==false and not sliding:
			_dash(get_local_mouse_position().normalized(),500)
			get_node("Camera/shiftBar").play("refill")
			$audioPlayers/bowShot.play()
	
	if Input.is_action_just_pressed("e"):
		if !parrying and get_node("Camera/eBar").is_playing()==false:
			parrying = true
			parryTime = .2
			if rad_to_deg(get_angle_to(get_global_mouse_position()))> 90 or rad_to_deg(get_angle_to(get_global_mouse_position()))<-90:
				get_node("parryBox").position.x=-13
			else:
				get_node("parryBox").position.x = 2
			get_node("Camera/eBar").play("refill")
			#make the parry act as a melee
			if $parryBox.has_overlapping_bodies():
				meleeCollideArray=$parryBox.get_overlapping_bodies()
				for x in meleeCollideArray:
					if x.is_in_group("Enemy"):
						x._meleeHit()
						$Camera/eBar.play("full")
			
	if parrying==true:
		animPlayer._parry()
		parryTime -= delta*1.2
		if parryTime <= 0:
			animPlayer._unParry()
			parrying = false
	
	move_and_slide()

func _slide(dir):
	$PlayerHitbox.position = Vector2(-6,10)
	$PlayerHitbox.rotation=90
	$PlayerHitbox.scale = Vector2(.2,1)
	if sliding==false:
		velocity.x=dir*SPEED*2
	sliding=true
	dashTime=.1
	_refreshArrowHud()
func _unSlide():
	if not Input.is_action_pressed("move_down"):
		$PlayerHitbox.position = Vector2(-4,5)
		$PlayerHitbox.rotation=0
		$PlayerHitbox.scale = Vector2(1,1)
		sliding=false


func _accelerate(dir):
	#Accelerate in whatever direction the player is wanting to move.
	#velocity = velocity.move_toward(Vector2(SPEED * dir, velocity.y), ACCEL)
	if ((velocity.x + ACCEL * dir) < -SPEED or (velocity.x + ACCEL * dir) > SPEED) and dashTime <= 0:
		velocity.x = SPEED * dir
	elif wallJumpNerf>0:
		velocity.x += (ACCEL-15) * dir
	else:
		velocity.x += ACCEL * dir

func _friction():
	#Add friction to the player
	#velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	if is_on_floor() and sliding==false:
		if (velocity.x > 0 and (velocity.x - FRICTION) < 0) or (velocity.x < 0 and (velocity.x + FRICTION) > 0):
			velocity.x = 0
		elif velocity.x > 0:
			velocity.x -= FRICTION
		elif velocity.x < 0:
			velocity.x += FRICTION
	else:
		if (velocity.x > 0 and (velocity.x - FRICTION) < 0) or (velocity.x < 0 and (velocity.x + FRICTION) > 0):
			velocity.x = 0
		elif velocity.x > 0:
			velocity.x -= AIR_FRICTION
		elif velocity.x < 0:
			velocity.x += AIR_FRICTION

func _gravity(delta):
	#Apply gravity
	velocity.y += gravity * delta
	

func _jump():
	#Jump
	if sliding==false:
		velocity.y = JUMP_VELOCITY
		$audioPlayers/jump.play()
	
	#CREATE VARIABLE HEIGHT JUMP
	#print(get_parent().velocity.y)

func _wallslide(delta):
	#Apply wall slide physics
	velocity.y += 1000 * delta
	max_fall_speed = 50
	wall_sliding = true

func _walljump():
	#Wall jump
	if sliding==false:
		if wall_sliding or direction == 0:
			velocity.y = JUMP_VELOCITY*.85
			velocity.x += -facing*SPEED*1.2
			facing *= -1
			wallJumpNerf=.25
			get_node("PlayerBodyAnimation")._quickturn()
			wall_sliding = false
			wallJumpCoyote = 0
		else:
			velocity.y = JUMP_VELOCITY*.85
			velocity.x += facing*SPEED*1.2
			facing *= -1
			wallJumpNerf=.25
			get_node("PlayerBodyAnimation")._quickturn()
			wall_sliding = false
			wallJumpCoyote = 0

func _aim(delta):
	if parryTime>0:
			pivot.rotation = get_angle_to(get_global_mouse_position())-parryTime*15+1
	#If the player is aiming.
	elif Input.is_action_pressed("right_click"):
		#Aim toward mouse position if the player isnt parrying
		if parryTime<=0:
			pivot.rotation = get_angle_to(get_global_mouse_position())
		
		
		#fire cooldown is the time where the bow guy is getting ready to fire the next shot,
		#which would need to decrease if aiming draws the bow anyways.
		fire_cooldown-=delta
		
		#charge_amount is the charge level of the bow
		if charge_amount<2.1 and fire_cooldown<=0:
			charge_amount += delta*1.2
		
		#Flip sprite to always be facing upward
		if (pivot.rotation_degrees > 90 or pivot.rotation_degrees < -90) and not weapon_flipped and bowTurning==true:
			weapon_sprite.scale.y *= -1
			weapon_flipped = false
			
		elif not (pivot.rotation_degrees > 90 or pivot.rotation_degrees < -90) and weapon_flipped and bowTurning==true:
			weapon_sprite.scale.y *= -1
			weapon_flipped = true
	elif shiftSlot == "Air" and shift_use_time >= 0:
		pivot.rotation = get_angle_to(get_global_mouse_position()) - PI
		if (pivot.rotation_degrees > 90 or pivot.rotation_degrees < -90) and not weapon_flipped and bowTurning==true:
			weapon_sprite.scale.y *= -1
			weapon_flipped = true
		elif not (pivot.rotation_degrees > 90 or pivot.rotation_degrees < -90) and weapon_flipped and bowTurning==true:
			weapon_sprite.scale.y *= -1
			weapon_flipped = false
	else:
		#if not aiming, just point straight in the direction
		if facing == 1 and weapon_flipped:
			pivot.rotation_degrees = 0
			weapon_sprite.scale.y *= -1
			weapon_flipped = false
		elif facing == -1 and not weapon_flipped:
			pivot.rotation_degrees = 180
			weapon_sprite.scale.y *= -1
			weapon_flipped = true
		elif facing == 1:
			pivot.rotation_degrees = -6
		elif facing == -1:
			pivot.rotation_degrees = 183
		
		
		#unless the bow is being quick fired, reset the bows chargetimer and fire cooldown
		if not (fire_state == "quick" or fire_state == "fireWhenReady"):
			fire_cooldown = FIRECOOLDOWN
			charge_amount = DEFAULTARROWSPEED
	
	if Input.is_action_pressed("right_click"):
		fire_state = "aim"
		animPlayer._shootAnim(fire_state)

func _shoot_check(delta):
	#if the bow isnt being drawn and you press fire, then quick fire. (if the or condition is met you dont have to keep pressing fire)
	animPlayer._shootAnim(fire_state)
	#print(fire_state)

	if (fire_cooldown == FIRECOOLDOWN and Input.is_action_just_pressed("left_click")) or fire_state == "quick" and not shift_use_time>0:
		fire_state= "quick"
		
		#run the timer down
		fire_cooldown-=delta*.7
		
		#fire
		if fire_cooldown <=0:
			charge_amount=1
			_shoot(delta)
			fire_cooldown=FIRECOOLDOWN
			fire_state="not"
	
	elif (fire_cooldown >0 and Input.is_action_pressed("right_click") and Input.is_action_just_pressed("left_click")) or fire_state=="fireWhenReady" and not shift_use_time>0:
		fire_state="fireWhenReady"
		
		#fire and reset the cooldown
		if fire_cooldown <=0:
			_shoot(delta)
			fire_cooldown=FIRECOOLDOWN*2
			fire_state="not"
	if Input.is_action_just_released("right_click") and fire_state=="aim" and not (fire_state=="fireWhenReady" or fire_state=="quick") and not shift_use_time>0 :
			fire_state="unAim"
			#animPlayer._shootAnim(fire_state)
			fire_cooldown=FIRECOOLDOWN
	
	if get_node("PivotHoldingArm/HoldingArmAnimation").alreadyUnAiming==false and get_node("PivotHoldingArm/HoldingArmAnimation").testVar == true and not shift_use_time>0:
		fire_state="not"
		
	
	#if the shooting cooldown is over, and you fire, then shoot.
	elif fire_cooldown<=0 and Input.is_action_just_pressed("left_click"):
		fire_cooldown=FIRECOOLDOWN*2
		fire_state="not"
		_shoot(delta)

func _shoot(delta):
	#Creates an instance of the arrow scene, sets inital rotation, and sets velocity to shoot at mouse
	var arrow = arrowPath.instantiate()
	#arrow._initialize_arrow(slots[arrow_hud_slot - 1], arrow_count, charge_amount, pivot.rotation_degrees, self)
	arrow._initialize_arrow(arrow_count, slots[arrow_hud_slot - 1], Vector2(500*charge_amount,0).rotated(pivot.rotation), pivot.rotation, self, inBulletTime)
	print(delta)
	arrow_count += 1
	add_sibling(arrow)
	arrow.position = get_node("PivotHoldingArm/HoldingArmAnimation/ArrowSpawn").global_position
	arrow.rotation = pivot.rotation
	#arrow.set_axis_velocity(Vector2(200*charge_amount,0).rotated(arrow.rotation))
	
	if Input.is_action_pressed("right_click"):
		fire_state = "aim"
	else: fire_state = "not"
	charge_amount=DEFAULTARROWSPEED
	if not fire_state=="quick":
		fire_state = "aim"
		animPlayer._justShot()
	#Resets the firestate and the cooldown timer

func _throw():
	var throwableInstance = throwablePath.instantiate()
	throwableInstance._initialize_arrow(throwable, Vector2(280,0).rotated(get_angle_to(get_global_mouse_position())), get_angle_to(get_global_mouse_position()), self, inBulletTime)
	throwable = ""
	add_sibling(throwableInstance)
	throwableInstance.position=$".".global_position
	
func _arrow_hud():
	if Input.is_action_just_pressed("mouse_wheel_up"):
		arrow_hud_slot+=arrow_hud_scroll_direction
		if arrow_hud_slot>=4:
			arrow_hud_slot=1
	elif Input.is_action_just_pressed("mouse_wheel_down"):
		arrow_hud_slot-=arrow_hud_scroll_direction
		if arrow_hud_slot<=0:
			arrow_hud_slot=3
	
	elif Input.is_action_just_pressed("num_1"):
		arrow_hud_slot=1
	elif Input.is_action_just_pressed("num_2"):
		arrow_hud_slot=2
	elif Input.is_action_just_pressed("num_3"):
		arrow_hud_slot=3
	
	if arrow_hud_slot == 1:
		arrowHud.play("slot_1")
	if arrow_hud_slot == 2:
		arrowHud.play("slot_2")
	if arrow_hud_slot== 3:
		arrowHud.play("slot_3")

func _dash(dir: Vector2, power):
	velocity = dir * power
	dashTime =.2
	shift_use_time=.2
	shift_cooldown = 1
	fire_cooldown=FIRECOOLDOWN
	fire_state="air-row"
	animPlayer.play("4air_quickfire")
	$PivotHoldingArm/HoldingArmAnimation/GPUParticles2D.emitting=true

func _take_damage(hp):
	if invincibilityFrames<0:
		health -= hp
		invincibilityFrames=INVINCIBILITYTIME
		if health==2:
			$Camera/healthBar.play("2")
		if health==1:
			$Camera/healthBar.play("1")
		if health==0:
			$Camera/healthBar.play("dead")
		if health==0:
			get_tree().change_scene_to_file("res://MainMenu.tscn")

func has_group(test):
	return

func _pivPos(pivX,pivY):
	piv.position.x=pivX
	piv.position.y=pivY
	
func _armPos(armX,armY):
	if fire_state != "aim" and fire_state != "quick":
		get_node("armPosition").position.x=armX
		get_node("armPosition").position.y=armY

func _pick_up_throwable():
	Global.pick_up.emit()

func _refreshArrowHud():
	if slots[0] == "Accuracy":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Accuracy")
	elif slots[0] == "Bounce":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Bounce")
	elif slots[0] == "Fire":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Fire")
	elif slots[0] == "Ghost":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Ghost")
	elif slots[0] == "Ice":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Ice")
	elif slots[0] == "Multi":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Multi")
	elif slots[0] == "Pierce":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Pierce")
	elif slots[0] == "Electricity":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Electric")
	
	if slots[1] == "Accuracy":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Accuracy")
	elif slots[1] == "Bounce":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Bounce")
	elif slots[1] == "Fire":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Fire")
	elif slots[1] == "Ghost":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Ghost")
	elif slots[1] == "Ice":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Ice")
	elif slots[1] == "Multi":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Multi")
	elif slots[1] == "Pierce":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Pierce")
	elif slots[1] == "Electricity":
		get_node("Camera/SelectedArrowHud/Slot_2").play("Electric")
	
	if slots[2] == "Accuracy":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Accuracy")
	elif slots[2] == "Bounce":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Bounce")
	elif slots[2] == "Fire":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Fire")
	elif slots[2] == "Ghost":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Ghost")
	elif slots[2] == "Ice":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Ice")
	elif slots[2] == "Multi":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Multi")
	elif slots[2] == "Multi":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Multi")
	elif slots[2] == "Pierce":
		get_node("Camera/SelectedArrowHud/Slot_3").play("Pierce")
	elif slots[2] == "Electricity":
		get_node("Camera/SelectedArrowHud/Slot_1").play("Electric")

func _hudUp():
	if hudUp == "down":
		if hudSpeed<19 and hudSlow == false:
			hudSpeed+=1
		else:
			hudSlow=true
		if hudSlow==true and hudSpeed>0:
			hudSpeed-=1
		elif hudSlow == true and hudSpeed == 0:
			hudUp = "isDown"
			hudSlow = false
		$InvintoryUI.position.y+=hudSpeed
	if hudUp == "up":
		if hudSpeed>-19 and hudSlow == false:
			hudSpeed-=1
		else:
			hudSlow=true
		if hudSlow==true and hudSpeed<0:
			hudSpeed+=1
		elif hudSlow == true and hudSpeed == 0:
			hudUp = "isUp"
			hudSlow = false
		$InvintoryUI.position.y+=hudSpeed
	pass

func _collector():
	collect=true

func _on_item_list_empty_clicked(at_position, mouse_button_index):
	pass # Replace with function body.
	
#func _transfer_data_between_scenes():
#	get_node("/root/PlayerVariablesGlobal") = {get_node()}

func _wet(delta):
	if wetTimer<=-999:
		wetTimer=3
		$wetParticles.emitting=true
	if wetTimer<=0:
		wetTimer=-999
		wet=false
		$wetParticles.emitting=false
	wetTimer-=delta
	print(wetTimer)
