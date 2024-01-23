extends Node2D
var playerIn=false
var playerInside=false
var menuSpeed=0
var menuTotalMove=0
var changing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerInside==true and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and menuSpeed==0:
		playerIn=true
		changing=false
	elif playerInside==true and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and menuSpeed==0:
		playerIn=false
		changing=false
		print("no")
	
	if playerIn==true:
		if menuSpeed<14 and changing == false:
			menuSpeed+=1
		
		if menuTotalMove>200:
			changing=true
		if changing == true and menuSpeed>0:
			menuSpeed-=1
		menuTotalMove+=menuSpeed
		$hiBitKeep.position.y-=menuSpeed

	if playerIn==false:
		if menuSpeed<14 and changing == false:
			menuSpeed+=1
		if menuTotalMove<20:
			changing=true
		if changing == true and menuSpeed>0:
			menuSpeed-=1
		menuTotalMove-=menuSpeed
		$hiBitKeep.position.y+=menuSpeed
	
	pass



func _on_player_detect_body_entered(body):
	if body.is_in_group("Player"):
		playerInside=true
		changing=false
	pass # Replace with function body.


func _on_player_detect_body_exited(body):
		if body.is_in_group("Player"):
			playerIn=false
			playerInside=false
			changing=false
		pass # Replace with function body.
