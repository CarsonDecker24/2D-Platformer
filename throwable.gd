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
var enemyList=[]
var enemyListCounter=0
var searchHolder
var batteryShockTimer=0
const BATTERYSHOCKSPEED=.1
var collisionEvent=""
var eventCount=0
var spin=0
var fading=false
var opacity=1
var thrown=false
var near_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.pick_up.connect(_on_pick_up)

func _initialize_arrow(aType: String, aVel: Vector2, aAngle, aPlayer: Node, bT):
	type = aType
	vel = aVel
	angle = aAngle
	player = aPlayer
	bulletTime = bT
	print(angle)
	print(vel)
	thrown = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if thrown and moving==true:
		_update_pos(delta)
	if type == "Battery":
		$AnimatedSprite2D.play("Battery")
	
	if type == "fireBottle":
		$AnimatedSprite2D.play("fireBottle")
	
	_check_ray()

	if collisionEvent=="Battery":
		_battery(delta)
		enemyList.sort_custom(_sort_by_distance)
	
	if collisionEvent=="fireBottle":
		_fireBottle(delta)
	
	if fading==true:
		_fading(delta)
	
	pass

func _update_pos(delta):
	position += vel * delta
	vel.y += GRAVITY * delta
	ray.target_position = vel * delta
	if not hideNextFrame:
		_check_ray()

func _check_ray():
	if ray.get_collider() != null:
		collision_point = ray.get_collision_point()

func _on_big_area_body_entered(body):
	if body.is_in_group("Enemy"):
		if type == "Battery":
			collisionEvent="Battery"
	if body.is_in_group("Enemy"):
		enemyList.append(body)
		enemyListCounter+=1
		body.inBatteryList=true
		enemyList.sort_custom(_sort_by_distance)

func _sort_by_distance(a, b):
	return abs(a.global_position - global_position) < abs(b.global_position - global_position)

func _on_big_area_body_exited(body):
	if body.is_in_group("Enemy"):
		searchHolder = enemyList.bsearch(body)
		enemyList.remove_at(searchHolder)
		enemyListCounter-=1
		body.inBatteryList=true

func _battery(delta):
	collisionEvent="Battery"
	if batteryShockTimer<=0:
		eventCount+=1
		batteryShockTimer=BATTERYSHOCKSPEED
	batteryShockTimer-=delta
	
	if eventCount>=1 and spin<1.5:
		spin+=delta
	$AnimatedSprite2D.rotation+=spin*.3
	
	if enemyList.size() >=1 and eventCount==2:
		$chain1.visible=true
		$chain1.size.x= sqrt((enemyList[0].global_position.x-global_position.x)**2 + (enemyList[0].global_position.y-global_position.y)**2)
		$chain1.rotation=get_angle_to(enemyList[0].global_position)

	if enemyList.size()>=2 and eventCount==2:
		$chain2.visible=true
		$chain2.set_global_position(enemyList[0].global_position)
		$chain2.size.x= sqrt((enemyList[1].global_position.x-enemyList[0].global_position.x)**2 + (enemyList[1].global_position.y-enemyList[0].global_position.y)**2)
		$chain2.rotation=atan2(enemyList[1].global_position.y - enemyList[0].global_position.y, enemyList[1].global_position.x - enemyList[0].global_position.x)

	if enemyList.size()>=3 and eventCount==2:
		$chain3.visible=true
		$chain3.set_global_position(enemyList[1].global_position)
		$chain3.size.x= sqrt((enemyList[2].global_position.x-enemyList[1].global_position.x)**2 + (enemyList[2].global_position.y-enemyList[1].global_position.y)**2)
		$chain3.rotation=atan2(enemyList[2].global_position.y - enemyList[1].global_position.y, enemyList[2].global_position.x - enemyList[1].global_position.x)
		
	elif eventCount>=3: 
		fading=true
		$chain1.visible=false
		$chain2.visible=false
		$chain3.visible=false
		
		var temp
		while enemyList.size()>0:
			temp = enemyList[0]
			temp.is_dead=true
			enemyList.remove_at(0)
	
	if eventCount>5:
		queue_free()

func _fireBottle(delta):
	var temp
	while enemyList.size()>0:
			temp = enemyList[0]
			temp.is_dead=true
			enemyList.remove_at(0)
	
	
	
	
	pass


func _fading(delta):
	$AnimatedSprite2D.self_modulate=Color(1, 1, 1, opacity)
	if opacity-delta*2.3>0:
		opacity-=delta*2.3
	else:
		opacity=0

func _on_pick_up():
	if near_player:
		player.throwable = type
		queue_free()

func _on_pick_up_area_area_entered(area):
	if area.is_in_group("Player"):
		near_player = true
		player = area.get_parent()

func _on_pick_up_area_area_exited(area):
	if area.is_in_group("Player"):
		near_player = false


func _on_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Ground"):
		moving=false
		collisionEvent=type
	pass # Replace with function body


func _on_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Ground"):
		moving=false
		collisionEvent=type
		if enemyList.size()==0:
			fading=true
	
	pass # Replace with function body.
