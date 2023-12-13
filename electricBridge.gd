extends Node2D
var source

# Called when the node enters the scene tree for the first time.
func _ready():
	source = get_node(get_meta("source"))
	get_node("StaticBody2D/CollisionShape2D").disabled = true
	$StaticBody2D/TextureRect.visible=false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if source != null and source.on==false:
		$StaticBody2D/TextureRect.visible=true
		get_node("StaticBody2D/CollisionShape2D").disabled = false
		$AnimatedSprite2D.play("on")
		print("wh")
