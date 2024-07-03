class_name BaseProjectile extends Area2D

var Speed: int = 1
var Direction: int = 1
var Damage: int = 1
var DestroyBulletTimer: Timer

func InitiateProjectile(speed: int, damage: int, destroyBulletTimer: Timer):
	Speed = speed
	Damage = damage
	Direction = 1
	DestroyBulletTimer = destroyBulletTimer

func _ready():
	connect("body_entered", ProjectileHit)
	DestroyBulletTimer.connect("timeout", DestroyBulletCuzTimerOut)

func _process(delta):
	move_local_x(Direction * Speed * delta)
	
func DestroyBulletCuzTimerOut():
	queue_free()
	
func ProjectileHit(body: BaseCharacter) -> void:
	body.TakeDamage(Damage)
	queue_free()
