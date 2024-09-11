class_name BaseCharacter extends CharacterBody2D

#CONSTS
var DEFAULT_GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity") #COULDN'T DEFINED BECAUSE OF ProjectSettings

#@EXPORTS
@export var MaxHealth: int = 10
@export var CurrentHealth: int = MaxHealth

#VARS
var AnimatedSprite2DNodeBaseCharacter: AnimatedSprite2D
var DirectionContainerNodeBaseCharacter: Node2D
var CollectedGunContainerNodeBaseCharacter: Node2D
var EquippedGun: BaseGun;
var CollectedDefaultGun: PackedScene;
var Speed: float = 100.0
var JumpVelocity: float = -150.0
var BlockAnimationPlay: bool = false
var gravity = DEFAULT_GRAVITY # Get the gravity from the project settings to be synced with RigidBody nodes.

signal HealthChanged

func InitilizeCharacter(
	speed: float,
	jumpVelocity: float,
	animatedSprite2DNode: AnimatedSprite2D, 
	directionContainerNode: Node2D,
	collectedGunContainerNode: Node2D,
	collectedDefaultGun: PackedScene) -> void:
		
	Speed = speed
	JumpVelocity = jumpVelocity
	AnimatedSprite2DNodeBaseCharacter = animatedSprite2DNode
	DirectionContainerNodeBaseCharacter = directionContainerNode
	CollectedGunContainerNodeBaseCharacter = collectedGunContainerNode
	CollectedDefaultGun = collectedDefaultGun

func TakeDamage(damage: int) -> void:
	print(get_groups()[0] + " took " + str(damage) + " damage.")
	DecreaseHealth(damage)
	
	if AnimatedSprite2DNodeBaseCharacter:
		PlayAnimation(Constants.CHARACTER_MOVEMENT_ANIMATIONS_HURT)
		if !AnimatedSprite2DNodeBaseCharacter.is_connected("animation_looped", HurtAnimationFinished):
			AnimatedSprite2DNodeBaseCharacter.connect("animation_looped", HurtAnimationFinished)
		
	if CurrentHealth <= 0:
		queue_free();

func HurtAnimationFinished() -> void:
	AnimatedSprite2DNodeBaseCharacter.disconnect("animation_looped", HurtAnimationFinished)
	if AnimatedSprite2DNodeBaseCharacter.animation == Constants.CHARACTER_MOVEMENT_ANIMATIONS_HURT:
		PlayAnimation(Constants.CHARACTER_MOVEMENT_ANIMATIONS_IDLE)

func ApplyGravity(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func MoveTowardsDirection(direction: float) -> void:
	if direction:
		if direction > 0 and DirectionContainerNodeBaseCharacter.scale != Vector2(1, 1): DirectionContainerNodeBaseCharacter.set_scale(Vector2(1, 1))
		elif direction < 0 and DirectionContainerNodeBaseCharacter.scale != Vector2(-1, 1): DirectionContainerNodeBaseCharacter.set_scale(Vector2(-1, 1))
		
		velocity.x = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		
	var animationName: StringName = AnimatedSprite2DNodeBaseCharacter.animation;
	if (velocity.x != 0 and 
			animationName != Constants.CHARACTER_MOVEMENT_ANIMATIONS_WALK and 
			animationName != Constants.CHARACTER_MOVEMENT_ANIMATIONS_HURT):
		PlayAnimation(Constants.CHARACTER_MOVEMENT_ANIMATIONS_WALK)
	elif (velocity.x == 0 and 
			animationName != Constants.CHARACTER_MOVEMENT_ANIMATIONS_IDLE and 
			animationName != Constants.CHARACTER_MOVEMENT_ANIMATIONS_HURT):
		PlayAnimation(Constants.CHARACTER_MOVEMENT_ANIMATIONS_IDLE)
	
	animationName = AnimatedSprite2DNodeBaseCharacter.animation;
	if !is_on_floor() and animationName !=  Constants.CHARACTER_MOVEMENT_ANIMATIONS_JUMP and animationName != Constants.CHARACTER_MOVEMENT_ANIMATIONS_HURT:
		PlayAnimation(Constants.CHARACTER_MOVEMENT_ANIMATIONS_JUMP)

func EquipGun(gunToCollect: PackedScene) -> void:
	if EquippedGun != null:
		EquippedGun.queue_free()
		
	EquippedGun = gunToCollect.instantiate() as BaseGun;
	CollectedGunContainerNodeBaseCharacter.add_child(EquippedGun)

func Shoot() -> void:
	if(EquippedGun):
		#DirectionContainer_Node.scale.x must be int allways
		var remainingBullet = EquippedGun.Shoot(int(DirectionContainerNodeBaseCharacter.scale.x));
		
		if(remainingBullet == 0 and CollectedDefaultGun != null):
			EquipGun(CollectedDefaultGun)

func Jump() -> void:
	velocity.y = JumpVelocity

func PlayAnimation(aninmationName: String, exceptBlocking: String = "") -> void:
	if(!BlockAnimationPlay || (BlockAnimationPlay and aninmationName == exceptBlocking)):
		AnimatedSprite2DNodeBaseCharacter.play(aninmationName)

func IncreaseHealth(health: int):
	CurrentHealth = CurrentHealth + health
	if CurrentHealth > MaxHealth:
		CurrentHealth = MaxHealth
		HealthChanged.emit()
	
func DecreaseHealth(damage: int):
	CurrentHealth = CurrentHealth - damage
	HealthChanged.emit()
