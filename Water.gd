extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#if body.has_group("Arrow"):
	#	if body.type == "Ice":
	#		get_node("StaticBody2D/CollisionShape2D").disabled = false
	print("this hella broken, dog")
