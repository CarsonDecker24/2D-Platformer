extends RigidBody2D
var test = true
var og_y_position
var grabbed_og=true
var vertical_change
var compared_to_previous

func _process(delta): 
	if grabbed_og == false:
		compared_to_previous =  (og_y_position-global_position.y)-vertical_change
	
	if grabbed_og == true:
		grabbed_og = false
		og_y_position = global_position.y
	vertical_change = og_y_position-global_position.y
	
	#print(compared_to_previous)
	pass

func _on_body_entered(body):
	if test == true :
		linear_velocity.x=0
		linear_velocity.y=0
		gravity_scale = 0
		sleeping= true
		#lock_rotation = true
		test=false
		

