extends Area2D
var lethal=false
var emitOnce=true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lethal==true and emitOnce==true:
		$GPUParticles2D.emitting=true
		emitOnce=false
	pass


func _on_body_entered(body):
	if body.is_in_group("Enemy") and lethal==true:
		if body.wet==true:
			body.is_dead=true
	pass # Replace with function body.

func _shock():
	$GPUParticles2D.emitting=true
