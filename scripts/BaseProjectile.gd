class_name BaseProjectile extends Area2D

#VARS
var DestroyBulletTimerNodeBaseProjectile: Timer
var Sprite2DNodeBaseProjectile: Sprite2D;
var CollisionShapeNodeBaseProjectile: CollisionShape2D;
var Damage: int = 1
var Speed: float = 1.0
var Direction: int = 1
var IsGunOnEnemyHands: bool = false

func InitiateProjectile(
	speed: float, 
	damage: int, 
	destroyBulletTimerNode: Timer, 
	sprite2DNode: Sprite2D, 
	collisionShape2DNode : CollisionShape2D) -> void:
	Speed = speed
	Damage = damage
	Direction = 1
	DestroyBulletTimerNodeBaseProjectile = destroyBulletTimerNode
	Sprite2DNodeBaseProjectile = sprite2DNode;
	CollisionShapeNodeBaseProjectile = collisionShape2DNode;
	
	Sprite2DNodeBaseProjectile.modulate = Color(Constants.PLAYER_BULLET_COLOR)
	
	if(IsGunOnEnemyHands == true):
		Speed = Speed / 10
		set_collision_mask_value(4, false)
		Sprite2DNodeBaseProjectile.modulate = Color(Constants.ENEMY_BULLET_COLOR)

func _ready() -> void:
	connect("body_entered", ProjectileHit)
	DestroyBulletTimerNodeBaseProjectile.connect("timeout", DestroyBulletCuzTimerOut)

func _process(delta) -> void:
	move_local_x(Direction *  Speed * delta)
	
func DestroyBulletCuzTimerOut() -> void:
	queue_free()

func ProjectileHit(body) -> void:
	if(body.is_in_group(Constants.GROUPS_PLAYER) ||body.is_in_group(Constants.GROUPS_ENEMY)):
		var character: BaseCharacter = body as BaseCharacter;
		character.TakeDamage(Damage)
		if body.is_in_group(Constants.GROUPS_ENEMY) and character.DirectionContainerNodeBaseCharacter.scale.x == scale.x:
			character.PreviousDirection = character.Direction
			character.Direction = character.Direction * -1;
		queue_free()
	else:
		queue_free()
