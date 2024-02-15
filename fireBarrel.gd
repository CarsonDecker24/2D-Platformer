extends Node2D
var entityList = []
var hasExploded=false
var searchHolder
var dissapearDelay=.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dissapearDelay<=0:
		$Sprite2D.visible=false
	
	if dissapearDelay<=-2:
		queue_free()
	
	if hasExploded==true:
		dissapearDelay-=delta


func _on_area_2d_area_entered(area):
	if area.is_in_group("Arrow"):
		if area.type=="Fire" and hasExploded==false:
			hasExploded=true
			var temp
			$fireExplosion.emitting=true
			while entityList.size()>0:
				temp = entityList[0]
				temp.is_dead=true
				entityList.remove_at(0)
			
			
		


func _on_area_2d_2_body_entered(body):
	if body.is_in_group("Enemy"):
		entityList.append(body)
		body.inBatteryList=true
	pass # Replace with function body.


func _on_area_2d_2_body_exited(body):
	if body.is_in_group("Enemy"):
		searchHolder = entityList.bsearch(body)
		entityList.remove_at(searchHolder)
		body.inBatteryList=true
	pass # Replace with function body.
