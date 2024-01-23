extends Node2D
var sceneStart=true
var sceneStartWalkTime=.45
var sceneStartWaitTime=-999
var closingPortal="not"
var portalColor = 1
var transitionTotalMoved=0
var transitState = "opening"
var transitionSpeed = 0


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
		$portalExit/exitBumper/CollisionShape2D.disabled=false
		closingPortal="closing"
	if closingPortal=="closing" and portalColor>0:
		$portalEnter.scale=Vector2(portalColor,portalColor)
		portalColor-=delta
	elif portalColor<0:
		$portalEnter.visible=false
		$portalExit/exitBumper/CollisionShape2D.disabled=false
	
	if transitionTotalMoved<200 and transitState=="opening" and not transitState=="closing":
		$Player/transition.position.y+=transitionSpeed*1.0
		transitionTotalMoved+=transitionSpeed
		if transitionSpeed <5:
			transitionSpeed+=2
		if transitionSpeed>0:
			transitionSpeed-=1
	elif (transitState !="closing" and transitState!="hidden" ):
		$Player/transition.visible=false
		transitionSpeed=0
		transitState="hidden"
	
	
	pass


func _on_player_detect_area_entered(area):
	pass # Replace with function body.
