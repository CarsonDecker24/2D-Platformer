extends AnimatedSprite2D
var alreadyAiming =false
var reset=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _shootAnim(fire_state):
	if fire_state == "not":
		play("bow_idle")
		alreadyAiming= false
	if fire_state == "fireWhenReady":
		play("bow_aim")
	if fire_state == "quick":
		play("bow_quickfire")
	if fire_state== "aim" and alreadyAiming == false:
		play("bow_aim")
		alreadyAiming = true
		
	if fire_state=="unAim":
		play_backwards("bow_aim")
		
		
	if fire_state=="unAim" and is_playing()==false:
		alreadyAiming=false
		play("bow_idle")
		reset=true
	
	
	print(is_playing())
