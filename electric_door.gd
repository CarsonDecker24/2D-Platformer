extends StaticBody2D

var on = false
var open = false
var openingTimer = 0
var playing=false
@onready var source = get_node(get_meta("source"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if source != null and source.on:
		if playing==true and $AnimatedSprite2D.is_playing()==false:
			on = true
			$AnimatedSprite2D.play("open")
		if on==false:
			$AnimatedSprite2D.play("opening")
			playing=true
		
	
	if on:
		open = true
	
	if open:
		get_node("CollisionShape2D").disabled = true
	else: 
		get_node("CollisionShape2D").disabled = false
