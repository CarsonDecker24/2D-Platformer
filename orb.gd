extends Area2D
var vel
var player

func _setup(v: Vector2, p: Node):
	vel = v
	player = p

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += vel
