extends Area2D
var vel: Vector2
var angle
var type: String
var player: Node
var id
var moving = true
const GRAVITY = 250
var arrowPath = preload("res://new_arrow.tscn")
@onready var ray = get_node("RayCast2D")
var on_enemy = false
var current_attached_body
var collision_point
#@onready var particle = get_node("particles")
#@onready var diePart = get_node("diePart")
var dyingTime=1
var dying = false
var hideNextFrame = false
var remainingBounces
var damage
var bulletTime
var EnemyList=[]
var enemyListCounter=0
var searchHolder
var batteryShockTimer=0
const BATTERYSHOCKSPEED=.2
var collisionEvent="Battery"
var batteryEventCount=0
var batterySpin=0
var fading=false
var opacity=1
var thrown=false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func _initialize_arrow(aID, aType: String, aVel: Vector2, aAngle, aPlayer: Node, bT):
	id = aID
	type = aType
	vel = aVel
	angle = aAngle
	player = aPlayer
	bulletTime = bT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if moving:
	#	_update_pos(delta)
	
	_check_ray()
	
	_battery(delta)
	EnemyList.sort_custom(_sort_by_distance)
	print(EnemyList)
	
	if collisionEvent=="Battery":
		_battery(delta)
	
	if fading==true:
		_fading(delta)
	
	pass

func _update_pos(delta):
	position += vel * delta
	vel.y += GRAVITY * delta
	ray.target_position = vel * delta
	if not hideNextFrame:
		_check_ray()
	rotation = atan2(vel.y,vel.x)

func _check_ray():
	if ray.get_collider() != null:
		collision_point = ray.get_collision_point()
		



func _on_big_area_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Ground"):
		if type == "Battery":
			collisionEvent="Battery"
	if body.is_in_group("Enemy"):
		EnemyList.append(body)
		enemyListCounter+=1
		body.inBatteryList=true
		EnemyList.sort_custom(_sort_by_distance)

func _sort_by_distance(a, b):
	return abs(a.global_position - global_position) < abs(b.global_position - global_position)

func _on_big_area_body_exited(body):
	if body.is_in_group("Enemy"):
		searchHolder = EnemyList.bsearch(body)
		EnemyList.remove_at(searchHolder)
		enemyListCounter-=1

func _battery(delta):
	collisionEvent="Battery"
	moving=false
	
	if batteryShockTimer<=0:
		batteryEventCount+=1
		batteryShockTimer=BATTERYSHOCKSPEED
	batteryShockTimer-=delta*.2
	
	if batteryEventCount>=1 and batterySpin<1.5:
		batterySpin+=delta
	$AnimatedSprite2D.rotation+=batterySpin*.1
	
	if EnemyList.size() >=1 and batteryEventCount==2:
		$chain1.visible=true
		$chain1.size.x= sqrt((EnemyList[0].global_position.x-global_position.x)**2 + (EnemyList[0].global_position.y-global_position.y)**2)
		$chain1.rotation=get_angle_to(EnemyList[0].global_position)
		fading=true
	if EnemyList.size()>=2 and batteryEventCount==3:
		$chain2.visible=true
		$chain1.visible=false
		$chain2.set_global_position(EnemyList[0].global_position)
		$chain2.size.x= sqrt((EnemyList[1].global_position.x-EnemyList[0].global_position.x)**2 + (EnemyList[1].global_position.y-EnemyList[0].global_position.y)**2)
		$chain2.rotation=atan2(EnemyList[1].global_position.y - EnemyList[0].global_position.y, EnemyList[1].global_position.x - EnemyList[0].global_position.x)
	if EnemyList.size()>=3 and batteryEventCount==4:
		$chain3.visible=true
		$chain2.visible=false
		$chain3.set_global_position(EnemyList[1].global_position)
		$chain3.size.x= sqrt((EnemyList[2].global_position.x-EnemyList[1].global_position.x)**2 + (EnemyList[2].global_position.y-EnemyList[1].global_position.y)**2)
		$chain3.rotation=atan2(EnemyList[2].global_position.y - EnemyList[1].global_position.y, EnemyList[2].global_position.x - EnemyList[1].global_position.x)
	if batteryEventCount==5:
		$chain3.visible=false
	pass # Replace with function body.
	

func _fading(delta):
	$AnimatedSprite2D.self_modulate=Color(1, 1, 1, opacity)
	if opacity-delta*.3>0:
		opacity-=delta*.3
	else:
		opacity=0
