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
	
	if body.is_in_group("Arrow"):
		if body.type == "Ice":
			get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", false)
			print("did that")
			_freeze()
		if body.type=="Fire":
			get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", true)
			print("did that")
			_thaw()

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

func _thaw():
	frameHolder = get_node("p1").frame
	get_node("p1").play("flow_rock")
	get_node("p1").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2").frame
	get_node("p1/p2").play("flow")
	get_node("p1/p2").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3").frame
	get_node("p1/p2/p3").play("flow")
	get_node("p1/p2/p3").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4").frame
	get_node("p1/p2/p3/p4").play("flow")
	get_node("p1/p2/p3/p4").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4/p5").frame
	get_node("p1/p2/p3/p4/p5").play("flow")
	get_node("p1/p2/p3/p4/p5").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4/p5/p6").frame
	get_node("p1/p2/p3/p4/p5/p6").play("flow")
	get_node("p1/p2/p3/p4/p5/p6").set_frame_and_progress(frameHolder,0.00)
	frameHolder = get_node("p1/p2/p3/p4/p5/p6/p7").frame
	get_node("p1/p2/p3/p4/p5/p6/p7").play("flow")
	get_node("p1/p2/p3/p4/p5/p6/p7").set_frame_and_progress(frameHolder,0.00)


func _on_area_2d_area_entered(area):
	if area.is_in_group("Arrow"):
		if area.type == "Ice":
			get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", false)
			print("did that")
			_freeze()
			area.moving = false
			area.hideNextFrame = true
			area.diePart.emitting=true
			area.dying = true
			area.particle.emitting=false
		if area.type=="Fire":
			get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", true)
			print("did that")
			_thaw()
			area.moving = false
			area.hideNextFrame = true
			area.diePart.emitting=true
			area.dying = true
			area.particle.emitting=false
