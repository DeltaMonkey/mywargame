class_name BaseCharacter extends CharacterBody2D

var Health: int = 10

func TakeDamage(damage: int):
	print(get_groups()[0] + " took " + str(damage) + " damage.")
	Health = Health - damage
	
	if Health <= 0:
		queue_free();
