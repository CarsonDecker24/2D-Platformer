extends Node2D
var frameHolder
var timerWater=0
var TIMERWATER= .05
var frozen=false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", true)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timerWater<=0 and frozen==false:
		if frameHolder==1:
			get_node("TextureRect").texture = load("res://Assets/environmental stuff/waterfall/wetWater0.png")
			frameHolder+=1
		elif frameHolder==2:
			get_node("TextureRect").texture= load("res://Assets/environmental stuff/waterfall/wetWater1.png")
			frameHolder+=1
		elif frameHolder==3:
			get_node("TextureRect").texture= load("res://Assets/environmental stuff/waterfall/wetWater2.png")
			frameHolder+=1
		else:
			get_node("TextureRect").texture= load("res://Assets/environmental stuff/waterfall/wetWater3.png")
			frameHolder=1
		timerWater=TIMERWATER
	timerWater-=delta
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
	frozen=true
	if frameHolder==1:
		get_node("TextureRect").texture = load("res://Assets/environmental stuff/waterfall/water_frozen0.png")
		frameHolder+=1
	elif frameHolder==2:
		get_node("TextureRect").texture= load("res://Assets/environmental stuff/waterfall/water_frozen1.png")
		frameHolder+=1
	elif frameHolder==3:
		get_node("TextureRect").texture= load("res://Assets/environmental stuff/waterfall/water_frozen2.png")
		frameHolder+=1
	else:
		get_node("TextureRect").texture= load("res://Assets/environmental stuff/waterfall/water_frozen3.png")
		frameHolder=1

func _thaw():
	frozen=false


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
