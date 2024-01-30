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
var level
var bulletTime
var EnemyList=[]
var enemyListCounter=0
var searchHolder
var chainAngle
var chainLength

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
		#_update_pos(delta)
	_chain()
	
	print(EnemyList)
	
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
		#particle.position = collision_point
		if type != "Bounce":
			hideNextFrame = true




func _on_big_area_body_entered(body):
	if body.is_in_group("Enemy"):
		EnemyList.append(body)
		enemyListCounter+=1
	EnemyList.sort_custom(_sort_by_distance)

func _sort_by_distance(a, b):
	return abs(a.global_position - global_position) < abs(b.global_position - global_position)

func _on_big_area_body_exited(body):
	if body.is_in_group("Enemy"):
		searchHolder = EnemyList.bsearch(body)
		EnemyList.remove_at(searchHolder)
		enemyListCounter-=1

func _chain():
	if EnemyList.size() >=1:
		$chain1.size.x= sqrt((EnemyList[0].global_position.x-global_position.x)**2 + (EnemyList[0].global_position.y-global_position.y)**2)
		$chain1.rotation=get_angle_to(EnemyList[0].global_position)
	if EnemyList.size()>=2:
		$chain2.set_global_position(EnemyList[0].global_position)
		$chain2.size.x= sqrt((EnemyList[1].global_position.x-EnemyList[0].global_position.x)**2 + (EnemyList[1].global_position.y-EnemyList[0].global_position.y)**2)
		$chain2.rotation=atan2(EnemyList[1].global_position.y - EnemyList[0].global_position.y, EnemyList[1].global_position.x - EnemyList[0].global_position.x)
	pass # Replace with function body.
