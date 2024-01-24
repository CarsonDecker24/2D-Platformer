extends CharacterBody2D
var player
var hp = 60
@onready var maxHp= hp
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
var speed_mod=2
var walking = "walking holster"
var idle = "idle holster"
var SPEED =120
const FIRE_RATE=2
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
var groundCheck = Vector2(1,1)
var ledgePosition = Vector2(0,0)
var distanceToLedge
var jumpInstance=false
var FRICTION = 25
var feetPos
var idleBehaviorTime=4
var generator=RandomNumberGenerator.new()
var idleBehaviorState="waiting"
var turnTest=false
var pauseWizardAim = false
var pauseWizardTimer = 0
var homing = false
var onFireTime=1
var onFireTickRate=.5
var onfireTickClock=0
var onFireDamage=0
var onFire = false
var deathTimer=0
var deathToss=false
var supriseTime
var meleRecieveComboTime=0
var meleComboIteration=0
var meleCrit=0.00
var meleconvert=0.00
const ThingyPath = preload("res://thingyFixed.tscn")

func _ready():
	get_node("ice_particles").set_deferred("emitting", false)
	get_node("suprised").visible=false
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
	_update_healthbar()
	if is_dead==true:
		player_spotted=false
		if deathTimer<0:
			queue_free()
		if deathToss==false:
			velocity.y=-300
			$CollisionShape2D.disabled=true
			deathToss=true
			var thingy = ThingyPath.instantiate()
			add_sibling(thingy)
			thingy.position=$thingySpawnPosition.global_position
		deathTimer-=delta
		animator.play("dead")
		$BaseRedHealthBar.visible=false
		$chargeHealthBar.visible=false
		$greenHealthBar.visible=false
	
	if is_dead==false:
		_check_rays()
		
		_shoot_orb(delta)
		#resets general stats when debufs are over
		if debuff_cooldown<0:
			speed_mod=1
			fire_rate_mod=1
			get_node("ice_particles").set_deferred("emitting", false)
		shoot_cooldown-=delta
		debuff_cooldown-=delta
		
		
		
		_player_spotted(delta)
		
		_idle_state(delta)
		
		_wizardAim()
		
		_turn_rays()
		
		_friction()
		
		_idle_state(delta)
		
		
		if pauseWizardTimer<0:
			pauseWizardAim=false
		pauseWizardTimer-=delta
		
		if onFire==true:
			if onFireTime<0:
				onFire=false
				pass
			if onfireTickClock<0:
				_lower_health(onFireDamage)
				onfireTickClock=onFireTickRate
			$fire_particles.emitting=true
		else:
			$fire_particles.emitting=false
		
		if oiled == true:
			$oilParticles2.emitting=true
		
		onFireTime-=delta
		onfireTickClock-=delta
	_gravity(delta)
	if meleRecieveComboTime>0:
		meleRecieveComboTime-=delta
	else:
		meleComboIteration=0
	



func _idle_state(delta):
	if is_dead ==true:
		pass
	if state=="neutral":
		if get_node("RayDown").get_collider() and not get_node("RayDown").get_collider() == null:
			if get_node("RayDown").get_collision_point():
				groundCheck=(get_node("RayDown").get_collision_point())
				feetPos = get_node("floorPositionNode").global_position
			#groundCheck stores the point of RayDowns last collision
			
			if groundCheck[1]<feetPos.y:
				ledgePosition=groundCheck
			#if the collision point of RayDown is lower than the platform TestDummy is standing on, it stores that position as the position of the ledge
			
			if ledgePosition!=null:
				$point.global_position=(get_node("RayDown").get_collision_point())
			distanceToLedge=abs(global_position.x-ledgePosition.x)
			
			if (distanceToLedge<14 and groundCheck[1]-2>feetPos.y and turnTest==false and is_on_floor()):
					
					turnTest=true
					if $dummyPlayer.flip_h==true:
						$dummyPlayer.flip_h=false
						
					else:
						$dummyPlayer.flip_h=true
					
			elif distanceToLedge<14 and groundCheck[1]-2<feetPos.y and turnTest==false:
				player_distance=170
				if jumpInstance==false and player_distance>150 and is_on_floor():
					velocity.y=-300
					jumpInstance=true
				if jumpInstance==false and player_distance<150:
					player_distance=90
		
		if jumpInstance==true:
			if $dummyPlayer.flip_h==false:
				velocity.x=100
			else:
				velocity.x=-100
		if is_on_floor()==true:
			jumpInstance=false
		
		
		if get_node("RayDown").get_collision_point().x!=null and get_node("RayUp").get_collision_point().x!=null:
			if get_node("RayDown").get_collision_point().x==get_node("RayUp").get_collision_point().x and turnTest==false:
				_turn_around()
				turnTest=true
			
		#if the behavior time runs out, switch behavior
		if turnTest==true and idleBehaviorTime<=0:
			turnTest=false
		if idleBehaviorTime<=0 and idleBehaviorState=="walking":
			idleBehaviorTime=generator.randf_range(1.00,3.00)
			idleBehaviorState="waiting"
		if idleBehaviorTime<=0 and idleBehaviorState=="waiting":
			idleBehaviorTime=generator.randf_range(5.00,6.00)
			idleBehaviorState="walking"
		
		if idleBehaviorState=="walking" and turnTest!=true:
				if animator.flip_h==true:
					velocity.x=-SPEED*speed_mod
				else:
					velocity.x=SPEED*speed_mod
				if animator.is_playing()==false and pauseWizardAim==false:
					animator.play("walking holster")
					
		elif (idleBehaviorState=="waiting" or turnTest==true) and pauseWizardAim==false:
			animator.play("idle holster")
		idleBehaviorTime-=delta*2


func _player_spotted(delta):
	if is_dead ==true:
		pass
	if player_spotted==true:
		#this line gets the players distance from the dummy
		
		if state == "neutral":
			supriseTime=.3
		if supriseTime>0:
			$suprised.visible=true
		else:
			$suprised.visible=false
		supriseTime-=delta
		state="sees_player"
		player_distance=sqrt((player.global_position.y-global_position.y) * (player.global_position.y-global_position.y) + ((player.global_position.x-global_position.x) * (player.global_position.x-global_position.x)))
		
		#loose track of player
		if player_distance>300:
			player_spotted=false
			state="neutral"
		
		#gets the point where raydown collides with the floor in this case.
		if get_node("RayDown").get_collider() and not get_node("RayDown").get_collider() == null:
			if get_node("RayDown").get_collision_point():
				groundCheck=(get_node("RayDown").get_collision_point())
				feetPos = get_node("floorPositionNode").global_position
			#groundCheck stores the point of RayDowns last collision
			
			if groundCheck[1]<feetPos.y:
				ledgePosition=groundCheck
			#if the collision point of RayDown is lower than the platform TestDummy is standing on, it stores that position as the position of the ledge
			
			if ledgePosition!=null:
				$point.global_position=(get_node("RayDown").get_collision_point())
			distanceToLedge=abs(global_position.x-ledgePosition.x)
			
			if distanceToLedge<13 and groundCheck[1]-2>feetPos.y:
					player_distance=90
			elif distanceToLedge<13 and groundCheck[1]-2<feetPos.y:
				if jumpInstance==false and player_distance>150 and is_on_floor():
					velocity.y=-300
					jumpInstance=true
					
				if jumpInstance==false and player_distance<150:
					player_distance=90
					
			
		
		
		if jumpInstance==true:
			if $dummyPlayer.flip_h==false:
				velocity.x=100
				
			else:
				velocity.x=-100
				
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
			get_node("Wand/shooting particles").set_deferred("emitting", true)
		
		#this flips the dummy to face the placer once the player has been spotted 
		if player.global_position.x>global_position.x:
			animator.flip_h=false
			player_side_right=true
		else:
			animator.flip_h=true
			player_side_right=false
		
		#this makes the dummy keep optimal distance with the player
		#minimise this to hide animation related things
		if player_distance>100 and is_on_floor() and pauseWizardAim==false:
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
				if animation_state=="walking" and animator.is_playing()==false :
					animator.play(walking)
					animation_state="walking"
				else:
					animator.play(walking)
					animation_state="walking"
		
		elif player_distance<40 and is_on_floor() and pauseWizardAim==false:
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
		elif pauseWizardAim==false:
			animator.play(idle)
func _wizardAim():
	if is_dead ==true:
		pass
	if player!=null and sees_player==true:
		get_node("Wand").self_modulate=Color(1, 1, 1, 1)
		if player_side_right==true:
			get_node("Wand").flip_h=true
			$Wand.offset= Vector2(2.5,-2.17)
			$"Wand/shooting particles".position=Vector2(2.5,-2.17)
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
			$"Wand/shooting particles".position=Vector2(-2.5,-2.17)
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
	elif pauseWizardAim==false:
		idle = "idle holster"
		walking = "walking holster"
		get_node("Wand").self_modulate=Color(1, 1, 1, 0)
	if $dummyPlayer.frame==0:
		get_node("Wand").position=Vector2(wandPos.x,wandPos.y)
	else:
		get_node("Wand").position=Vector2(wandPos.x,wandPos.y-1.25)
		
	

func _lower_health(hp_reduction: int):
	hp -= hp_reduction
	if (hp <= 0):
		is_dead = true
		deathTimer=.7
	_hit_animation()
	_update_healthbar()


#Deal damage, requires arrow type
func _damage(type: String, damage: int):
	meleconvert=0.00
	if type == "Ice":
		hp -= damage
		meleconvert=damage
		meleCrit+=meleconvert*.4
		debuff_cooldown=3
		speed_mod=.5
		fire_rate_mod=.7
		get_node("ice_particles").set_deferred("emitting", true)
	elif type == "Fire":
		hp -= damage 
		meleconvert=damage
		meleCrit+=meleconvert*.4
		if oiled==true:
			hp-=300
		oiled = false
		onFire=true
		onFireTime=4
		onfireTickClock=onFireTickRate
		onFireDamage=2
	elif type == "Electricity":
		hp -= damage
		meleconvert=damage
		meleCrit+=meleconvert*.8
	else:
		hp -= damage
	if (hp <= 0):
		is_dead = true
		deathTimer=.7
		
	if player_spotted==false:
		_turn_around()
	_hit_animation()
	_update_healthbar()

func _update_healthbar():
	$BaseRedHealthBar.visible=true
	$greenHealthBar.visible=true
	if meleCrit==0:
		$greenHealthBar.size.x=18*hp/maxHp
		$chargeHealthBar.size.x=0
	elif 18*(((hp-meleCrit)/maxHp)):
		$greenHealthBar.size.x=18*(((hp-meleCrit)/maxHp))
		$chargeHealthBar.size.x=18*hp/maxHp
	else:
		$greenHealthBar.visible=false
		$chargeHealthBar.size.x=18*hp/maxHp
func _hit_animation():
	if walking=="walking down":
		pauseWizardAim=true
		animator.stop()
		animator.play("downHurt")
		pauseWizardTimer=.1
	elif walking=="walking up":
		pauseWizardAim=true
		animator.stop()
		animator.play("upHurt")
		pauseWizardTimer=.1
	elif walking=="walking level":
		pauseWizardAim=true
		animator.stop()
		animator.play("levelHurt")
		pauseWizardTimer=.1
	elif walking=="walking upwards":
		pauseWizardAim=true
		animator.stop()
		animator.play("upwardsHurt")
		pauseWizardTimer=.1


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
		orb._setup(Vector2(200,0).rotated(_get_angle_to_player()), player, get_meta("homing"),player_side_right)
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

func _turn_around():
	if $dummyPlayer.flip_h==true:
		$dummyPlayer.flip_h=false
	else:
		$dummyPlayer.flip_h=true
	#print("player side right:",player_side_right)
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

func _meleHit():
	if meleRecieveComboTime>0:
		meleComboIteration+=1
	meleRecieveComboTime=.5
	if player_side_right==true and meleComboIteration==0:
		velocity.x=-80
		velocity.y=-120
	elif meleComboIteration==0:
		velocity.x=80
		velocity.y=-120
	elif player_side_right==true and meleComboIteration==1:
		velocity.x=-160
		velocity.y=-180
	elif meleComboIteration==1:
		velocity.x=160
		velocity.y=-180
	bouttaShoot=false
	_lower_health(5)
	_lower_health(meleCrit)
	meleCrit=0
	if player_spotted==false:
		_turn_around()
	
