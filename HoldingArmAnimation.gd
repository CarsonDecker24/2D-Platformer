extends AnimatedSprite2D
var alreadyAiming =false
var alreadyUnAiming=false
var testVar = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _shootAnim(fire_state):
	if fire_state == "not":
		play("bow_idle")
		alreadyUnAiming=false
		alreadyAiming= false
		testVar=false
	if fire_state == "fireWhenReady":
		play("bow_aim")
	if fire_state == "quick":
		play("bow_quickfire")
	if fire_state== "aim" and alreadyAiming == false:
		play("bow_aim")
		alreadyAiming = true
	if fire_state=="unAim" and alreadyUnAiming==false:
		play_backwards("bow_aim")
		alreadyUnAiming=true
		
	if alreadyUnAiming==true and is_playing()==false:
		play("bow_idle")
		alreadyUnAiming=false
		testVar=true

func _justShot():
	stop()
	alreadyAiming = false
	
	

