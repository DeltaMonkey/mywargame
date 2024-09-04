class_name BaseCharacter extends CharacterBody2D

var DEFAULT_GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var Speed: int = 100
var JumpVelocity: int = -150
var Health: int = 10
var AnimatedSprite2D_Node: AnimatedSprite2D
var DirectionContainer_Node: Node2D
var EquippedGun: BaseGun;
var CollectedDefaultGun: PackedScene;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = DEFAULT_GRAVITY

func InitilizeCharacter(
	speed: int,
	jumpVelocity: int,
	animatedAprite2D: AnimatedSprite2D, 
	directionContainer_Node: Node2D,
	collectedDefaultGun: PackedScene):
		
	Speed = speed
	JumpVelocity = jumpVelocity
	AnimatedSprite2D_Node = animatedAprite2D
	DirectionContainer_Node = directionContainer_Node
	CollectedDefaultGun = collectedDefaultGun

func TakeDamage(damage: int):
	print(get_groups()[0] + " took " + str(damage) + " damage.")
	Health = Health - damage
	
	if AnimatedSprite2D_Node:
		AnimatedSprite2D_Node.play("hurt")
		if !AnimatedSprite2D_Node.is_connected("animation_looped", HurtAnimationFinished):
			AnimatedSprite2D_Node.connect("animation_looped", HurtAnimationFinished)
		
	if Health <= 0:
		queue_free();

func HurtAnimationFinished():
	AnimatedSprite2D_Node.disconnect("animation_looped", HurtAnimationFinished)
	if AnimatedSprite2D_Node.animation == "hurt":
		AnimatedSprite2D_Node.play("idle")

func ApplyGravity(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func MoveTowardsDirection(direction: float):
	if direction:
		if direction > 0 and DirectionContainer_Node.scale != Vector2(1, 1): DirectionContainer_Node.set_scale(Vector2(1, 1))
		elif direction < 0 and DirectionContainer_Node.scale != Vector2(-1, 1): DirectionContainer_Node.set_scale(Vector2(-1, 1))
		
		velocity.x = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		
	var animationName: StringName = AnimatedSprite2D_Node.animation;
	if (velocity.x != 0 and 
			animationName != 'walk' and 
			animationName != 'hurt'):
		AnimatedSprite2D_Node.play("walk")
	elif (velocity.x == 0 and 
			animationName != 'idle' and 
			animationName != 'hurt'):
		AnimatedSprite2D_Node.play('idle')
	
	animationName = AnimatedSprite2D_Node.animation;
	if !is_on_floor() and animationName != 'jump' and animationName != 'hurt':
		AnimatedSprite2D_Node.play('jump')

func EquipGun(gunToCollect: PackedScene):
	if EquippedGun != null:
		EquippedGun.queue_free()
		
	EquippedGun = gunToCollect.instantiate() as BaseGun;
	DirectionContainer_Node.add_child(EquippedGun)

func Shoot():
	if(EquippedGun):
		var remainingBullet = EquippedGun.Shoot(DirectionContainer_Node.scale.x);
		
		if(remainingBullet == 0 and CollectedDefaultGun != null):
			EquipGun(CollectedDefaultGun)

func Jump():
	velocity.y = JumpVelocity
