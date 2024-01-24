extends Node2D

var falling = false
var gravity = .1#ProjectSettings.get_setting("physics/2d/default_gravity")
var vel = 0
var explodeTimer=.3
var exploding=false
var particled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node(get_meta("attachment")) == null:
		falling = true

	if falling:
		vel += gravity
		global_position.y += vel
	if exploding==true:
		if particled==false:
			$CPUParticles2D.emitting=true
			particled=true
		explodeTimer-=delta
		if explodeTimer<0:
			queue_free()
		$bottleArea/AnimatedSprite2D.rotate(delta)
		get_node("explosionHitbox/CollisionShape2D").disabled = false

func _explode():
	#enable explosion hitbox and apply oil effect
	queue_free()


func _on_bottle_area_body_entered(body):
	if falling:
		exploding=true

func _on_explosion_hitbox_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Player"):
		body.oiled = true
