extends Node2D
var transitionSpeed=0
var transitionTotalMoved=0
var transitState = "opening"
@onready var player_start_pos = $Player.position
var bg_move_speed1 = .7
@onready var bg_start_x1= $bg_1.position.x
@onready var bg_start_y1= $bg_1.position.y
var bg_move_speed2=.9
@onready var bg_start_x2 = $bg_2.position.x
@onready var bg_start_y2 = $bg_2.position.y
var playerPosChangeX
var playerPosChangeY
var sceneLightingDirection=true
var sceneLightingValue=0
var sceneLightingMomentum=0
var sceneLightingMult
var sceneStart=true
var sceneStartWalkTime=.45
var sceneStartWaitTime=-999
var closingPortal="not"
var portalColor=1
var exitingLevel=false
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.action_press("move_right")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sceneStart==true and sceneStartWalkTime>0:
		Input.action_press("move_right")
		sceneStartWalkTime-=delta
	elif sceneStart==true and sceneStartWalkTime<=0 and sceneStartWaitTime==-999:
		Input.action_release("move_right")
		sceneStart=false
		$SceneStartCollision/CollisionShape2D.disabled=false
		closingPortal="closing"
	if closingPortal=="closing" and portalColor>0:
		$portalEnter.scale=Vector2(portalColor,portalColor)
		portalColor-=delta
	elif portalColor<0:
		$portalEnter.visible=false
	
	
	
	if transitionTotalMoved<200 and transitState=="opening":
		$Player/transition.position.y-=transitionSpeed*1.0
		transitionTotalMoved-=transitionSpeed
		if transitionSpeed <5:
			transitionSpeed+=2
		if transitionSpeed>0:
			transitionSpeed-=1
	elif transitState !="closing" or transitState!="hidden":
		$Player/transition.visible=false
		transitionSpeed=0
		transitionTotalMoved=0
		transitState="hidden"
		print("bad")
	
	if transitionTotalMoved<200 and transitState=="closing":
		$Player/transition.visible=true
		$Player/transition.position.y+=transitionSpeed*1.0
		transitionTotalMoved-=transitionSpeed
		if transitionSpeed <5:
			transitionSpeed+=2
		if transitionSpeed>0:
			transitionSpeed-=1
	elif transitState != "opening" or transitState!="hidden":
		transitionSpeed=0
		transitionTotalMoved=0
		transitState="hidden"
	print("hey its",transitState)
	
	
	
	
	
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
	pass
	

func _input(event):
	if event.is_action_pressed("return_to_main_menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")










func _on_scene_exit_trigger_body_entered(body):
	if body.is_in_group("Player"):
		transitState="closing"
		
	pass # Replace with function body.
