extends Node2D
var transitionSpeed=0
var transitionTotalMoved=0
@onready var player_start_pos = $Player.position
var bg_move_speed1 = .7
@onready var bg_start_x1= $bg_1.position.x
@onready var bg_start_y1= $bg_1.position.y
var bg_move_speed2=.4
@onready var bg_start_x2 = $bg_2.position.x
@onready var bg_start_y2 = $bg_2.position.y
var playerPosChangeX
var playerPosChangeY
var sceneLightingDirection=true
var sceneLightingValue=0
var sceneLightingMomentum=0
var sceneLightingMult
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if transitionTotalMoved<200:
		$Player/transition.position.y-=transitionSpeed*1.0
		transitionTotalMoved-=transitionSpeed
		if transitionSpeed <5:
			transitionSpeed+=2
		if transitionSpeed>0:
			transitionSpeed-=1
	else:
		$Player/transition.queue_free()
	playerPosChangeX= $Player.position.x-player_start_pos.x
	playerPosChangeY= $Player.position.y-player_start_pos.y
	$bg_1.position=Vector2((playerPosChangeX*bg_move_speed1)+bg_start_x1,(playerPosChangeY*bg_move_speed1)+bg_start_y1)
	$bg_2.position=Vector2((playerPosChangeX*bg_move_speed2)+bg_start_x2,(playerPosChangeY*bg_move_speed2)+bg_start_y2)
	
	if sceneLightingDirection==true:
		if sceneLightingValue>.98:
			sceneLightingDirection=false
		$bg_2/Sprite2D.self_modulate= Color(1,1,1,sceneLightingValue*1.00)
		sceneLightingValue+=.002
	else:
		if sceneLightingValue<.5:
			sceneLightingDirection=true
		$bg_2/Sprite2D.self_modulate= Color(1,1,1,sceneLightingValue*1.00)
		sceneLightingValue-=.002
	print(sceneLightingValue)
	pass
	

func _input(event):
	if event.is_action_pressed("return_to_main_menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
