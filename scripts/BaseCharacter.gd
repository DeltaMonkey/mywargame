class_name BaseCharacter extends CharacterBody2D

var Health: int = 10
var AnimatedSprite2D_Node: AnimatedSprite2D

func InitilizeCharacter(animatedAprite2D: AnimatedSprite2D = null):
	AnimatedSprite2D_Node = animatedAprite2D

func TakeDamage(damage: int):
	print(get_groups()[0] + " took " + str(damage) + " damage.")
	Health = Health - damage
	
	if AnimatedSprite2D_Node:
		AnimatedSprite2D_Node.play("hurt")
		AnimatedSprite2D_Node.connect("animation_looped", HurtAnimationFinished)
		
	if Health <= 0:
		queue_free();

func HurtAnimationFinished():
	AnimatedSprite2D_Node.disconnect("animation_looped", HurtAnimationFinished)
	if AnimatedSprite2D_Node.animation == "hurt":
		AnimatedSprite2D_Node.play("idle")
