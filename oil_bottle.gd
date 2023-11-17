extends Node2D

var falling = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var vel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !get_parent().is_in_group("Rope"):
		falling = true
	
	if falling:
		vel += gravity
		global_position.y += vel

func _explode():
	#enable explosion hitbox and apply oil effect
	queue_free()


func _on_bottle_area_body_entered(body):
	if falling:
		_explode()
