extends Node2D
var equipped = ["Fire","Electricity","Ice","Amulet","Air"]
var Invintory = ["Fire","Electricity","Ice","Amulet","Air"]
var thingyCount=0
var thingyConv = ""
var play=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"..".collect==true:
		$"../audioPlayers/thingyCollect".play()
		$"..".collect=false

	print(play,"PLAYYYYY")
	print($"..".collect)
	pass




func _on_item_list_item_selected(index):
	if Invintory[index] == "Fire":
		$InvintoryBackDrop/RichTextLabel.text= "Fire Arrows\nTheese arrows will set your targets ablaze.\n"
	elif Invintory[index] == "Electricity":
		$InvintoryBackDrop/RichTextLabel.text= "Electric Arrows\nTheese arrows will shock their target, and power electronics."
	elif Invintory[index] == "Ice":
		$InvintoryBackDrop/RichTextLabel.text= "Ice Arrows \nTheese arrows will slow their targets movement and attack speed.\nTry freezing things in the environment."
	elif Invintory[index] == "Amulet":
		$InvintoryBackDrop/RichTextLabel.text= "You cant remember how you aquired this amulet, or why its threads tighten when you try to remove it."
	elif Invintory[index] == "Air":
		$InvintoryBackDrop/RichTextLabel.text= "The Air-rows launch you through the air.\nIf they requited less magica to use, you could use them more often,\nbut for right now we shouldnt exaust the enchantments on the bow before they can regenerate."
	pass # Replace with function body.


func _on_area_2d_area_entered(body):
	if body.is_in_group("Thingy"):
		$"..".collect=true
		thingyCount+=1
		
		$InvintoryBackDrop/thingyCountLabel.text= " {0}".format([thingyCount])
		print("thingy count is",thingyCount)
	
	pass # Replace with function body.
