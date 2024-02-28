extends Node2D
var startDelay=.2
var started = false
@onready var playerPos=$player.global_position
var player
var playerSpeed=1
var playerUpSpeed=.5
var playerDirectionRight=false
var playerDirectionUp=true
var backPos = 0
var backPos2 = 0
var infrontPos1=0
var infrontPos2=0


# Called when the node enters the scene tree for the first time.
func _ready():
	$music.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if started ==true:
		startDelay-=delta
		$transition.self_modulate=Color(0, 0, 0, 1.0-(5*startDelay))
		$transition.z_index=2
		if startDelay<=0:
			get_tree().change_scene_to_file("res://level_1.tscn")
	
	backPos=$back1.position.y
	backPos2=$back2.position.y 
	infrontPos1=$background1.position.y
	infrontPos2=$background2.position.y
	
	$back1.position.y-=.8
	$back2.position.y-=.8
	$background1.position.y-=.5
	$background2.position.y-=.5
	
	if $back1.position.y<-1205:
		$back1.position.y=1300
	if  $back2.position.y<-1205:
		$back2.position.y=1300
	if $background1.position.y<-1205:
		$background1.position.y=1300
	if $background2.position.y<-1205:
		$background2.position.y=1300
	
	if playerSpeed>1 and playerDirectionRight==true:
		playerDirectionRight=false
	if playerSpeed<-1 and playerDirectionRight==false:
		playerDirectionRight=true
	if playerDirectionRight==true:
		playerSpeed+=delta
	if playerDirectionRight==false:
		playerSpeed-=delta
	$player.position.x+=playerSpeed
	
	if playerUpSpeed>.3 and playerDirectionUp==true:
		playerDirectionUp=false
	if playerUpSpeed<-.3 and playerDirectionUp==false:
		playerDirectionUp=true
	if playerDirectionUp==true:
		playerUpSpeed+=delta
	if playerDirectionUp==false:
		playerUpSpeed-=delta
	$player.position.y+=playerUpSpeed
	
	
	
	
	
	pass
func _on_start_button_pressed():
	#change scene when putton pressed
	started=true


func _on_music_finished():
	$music.play()
	pass # Replace with function body.
