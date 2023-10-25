extends Node2D
var frameHolder

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("bad")
	if body.is_in_group("Arrow"):
		if body.type == "Ice":
			get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", false)
			print("did that")
			_freeze()

func _freeze():
	frameHolder = get_node("p1").frame
	get_node("p1").play("frozen_rock")
	get_node("p1").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2").frame
	get_node("p1/p2").play("frozen")
	get_node("p1/p2").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3").frame
	get_node("p1/p2/p3").play("frozen")
	get_node("p1/p2/p3").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4").frame
	get_node("p1/p2/p3/p4").play("frozen")
	get_node("p1/p2/p3/p4").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4/p5").frame
	get_node("p1/p2/p3/p4/p5").play("frozen")
	get_node("p1/p2/p3/p4/p5").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4/p5/p6").frame
	get_node("p1/p2/p3/p4/p5/p6").play("frozen")
	get_node("p1/p2/p3/p4/p5/p6").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4/p5/p6/p7").frame
	get_node("p1/p2/p3/p4/p5/p6/p7").play("frozen")
	get_node("p1/p2/p3/p4/p5/p6/p7").set_frame_and_progress(frameHolder,0.00)
