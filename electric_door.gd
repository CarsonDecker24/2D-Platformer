extends StaticBody2D

var on = false
var open = false
var openingTimer = 0
var playing=false
var levelTrigger=false
var source 

# Called when the node enters the scene tree for the first time.
func _ready():
	source = get_node(get_meta("source"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if source != null and source.on and levelTrigger==false:
		if playing==true and $AnimatedSprite2D.is_playing()==false:
			on = true
			$AnimatedSprite2D.play("open")
			playing = false
		if on==false and levelTrigger==false:
			$AnimatedSprite2D.play("opening")
			playing=true
	
	
	if levelTrigger==true and playing == true and $AnimatedSprite2D.is_playing()==false:
		$AnimatedSprite2D.play("closed")
		playing == false
		open = false
		
	if levelTrigger == true and not on == false:
		$AnimatedSprite2D.play_backwards("opening")
		playing == true
		on = false

	if on:
		open = true
	else:
		open=false

	
	if open == true and levelTrigger==false:
		get_node("CollisionShape2D").disabled = true
	else: 
		get_node("CollisionShape2D").disabled = false


func _on_door_controller_body_entered(body):
	if body.is_in_group("Player"):
		levelTrigger=true
		get_node(get_meta("source")).on=false
	pass # Replace with function body.


func _on_door_opener_body_entered(body):
	#this is me throwing code at it till it's collision turns off
	levelTrigger=false
	on = false
	open=true
	get_node(get_meta("source")).on=false
	get_node("CollisionShape2D").disabled = true
	pass # Replace with function body.
