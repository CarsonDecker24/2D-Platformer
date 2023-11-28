extends StaticBody2D

var on = false
var open = false
var openingTimer = 0
@onready var source = get_node(get_meta("source"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if source.on:
		on = true
	
	if on:
		open = true
	
	if open:
		get_node("CollisionShape2D").disabled = true
	else: 
		get_node("CollisionShape2D").disabled = false
