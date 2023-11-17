extends AnimatedSprite2D
var alreadyAiming =false
var alreadyUnAiming=false
var testVar = false
var parry = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _shootAnim(fire_state):
	if fire_state == "not" and parry==false:
		play("bow_idle")
		alreadyUnAiming=false
		alreadyAiming= false
		testVar=false
	if fire_state == "fireWhenReady" and parry==false :
		play("bow_aim")
	if fire_state == "quick":
		play("bow_quickfire")
	if fire_state== "aim" and alreadyAiming == false and parry==false:
		play("bow_aim")
		alreadyAiming = true
	if fire_state=="unAim" and alreadyUnAiming==false and parry==false:
		play_backwards("bow_aim")
		alreadyUnAiming=true
	if alreadyUnAiming==true and is_playing()==false and parry==false:
		play("bow_idle")
		alreadyUnAiming=false
		testVar=true
	if fire_state=="air-row" and parry==false:
		play("4air_quickfire")
	if fire_state=="air-row" and is_playing()==false:
		play("bow_idle")

func _justShot():
	stop()
	alreadyAiming = false

func _parry():
	play("parry")
	parry=true
func _unParry():
	parry=false
