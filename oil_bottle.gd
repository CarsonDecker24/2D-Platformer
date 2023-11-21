extends Node2D

var falling = false
var gravity = .1#ProjectSettings.get_setting("physics/2d/default_gravity")
var vel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node(get_meta("attachment")) == null:
		print("poof")
		falling = true

	if falling:
		vel += gravity
		global_position.y += vel

func _explode():
	#enable explosion hitbox and apply oil effect
	get_node("explosionHitbox/CollisionShape2D").disabled = false
	queue_free()


func _on_bottle_area_body_entered(body):
	if falling:
		_explode()

func _on_explosion_hitbox_body_entered(body):
	if body.has_group("Enemy") or body.has_group("Player"):
		body.oiled = true
