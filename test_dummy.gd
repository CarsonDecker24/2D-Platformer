extends CharacterBody2D

var hp = 5
var is_dead = false

func _physics_process(delta):
	move_and_slide()

func _lower_health(hp_reduction: int):
	hp -= hp_reduction
	print("Remaining HP: " + str(hp))
	if (hp <= 0):
		print("Died!")
		is_dead = true
		queue_free()

#Deal damage, requires arrow type
func _damage(type: String, damage: int):
	if type == "Fire":
		hp -= damage
	print("Remaining HP: " + str(hp))
	if (hp <= 0):
		print("Died!")
		is_dead = true
		queue_free()

func _is_dead():
	return is_dead

func _func_on_body_entered():
	print("youch")

func _on_body_entered(body):
	print(body)
