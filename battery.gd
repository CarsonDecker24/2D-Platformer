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
	pass # Replace with function body.


func _on_big_area_body_exited(body):
	if body.is_in_group("Enemy"):
		searchHolder = EnemyList.bsearch(body)
		EnemyList.remove_at(searchHolder)
		enemyListCounter-=1

	pass # Replace with function body.
