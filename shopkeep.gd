extends Node2D
var sceneStart=true
var sceneStartWalkTime=.45
var sceneStartWaitTime=-999
var closingPortal="not"
var portalColor = 1

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
		
	pass
