class_name BaseProjectile extends Area2D

var Speed: float = 1.0
var Direction: int = 1
var Damage: int = 1
var DestroyBulletTimer: Timer
var Sprite: Sprite2D;
var CollisionShape: CollisionShape2D;

var IsGunOnEnemyHands: bool = false

func InitiateProjectile(speed: float, damage: int, destroyBulletTimer: Timer , sprite: Sprite2D, collisionShape : CollisionShape2D):
	Speed = speed
	Damage = damage
	Direction = 1
	DestroyBulletTimer = destroyBulletTimer
	Sprite = sprite;
	CollisionShape = collisionShape;
	
	Sprite.modulate = Color("#FABC3F")
	
	if(IsGunOnEnemyHands == true):
		Speed = Speed / 10
		set_collision_mask_value(4, false)
		Sprite.modulate = Color("#E85C0D")
	
func _ready():
	connect("body_entered", ProjectileHit)
	DestroyBulletTimer.connect("timeout", DestroyBulletCuzTimerOut)

func _process(delta):
	move_local_x(Direction *  Speed * delta)
	
func DestroyBulletCuzTimerOut():
	queue_free()
	
func ProjectileHit(body) -> void:
	if(body.is_in_group("player") || body.is_in_group("enemy")):
		var character = body as BaseCharacter;
		character.TakeDamage(Damage)
		if character.DirectionContainer_Node.scale.x == scale.x:
			character.PreviousDirection = character.Direction
			character.Direction = character.Direction * -1;
		queue_free()
	else:
		queue_free()
