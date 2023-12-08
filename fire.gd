extends Node2D
var status = "lit"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("RayCast2D").get_collider() and not get_node("RayCast2D").get_collider() == null and get_node("RayCast2D").get_collider().is_in_group("SteamCollector"):
		if status == "lit":
			get_node("RayCast2D").get_collider()._powered()
		elif status == "out":
			get_node("RayCast2D").get_collider()._unPowered()
		else:
			print("nope")
		print(get_node("RayCast2D").get_collider())
	
	print(get_node("RayCast2D").get_collider())
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("Arrow") and status == "lit":
		if area.type == "Ice":
			$fire.play("out")
			$fire/pot.play("out")
			status = "out"
			$CPUParticles2D.emitting = false
	if area.is_in_group("Arrow") and status == "out":
		if area.type == "Fire":
			$fire.play("lit")
			$fire/pot.play("lit")
			status="lit"
			$CPUParticles2D.emitting = true
	
	pass # Replace with function body.
