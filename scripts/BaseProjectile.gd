class_name BaseProjectile extends Area2D

var Speed: int = 1
var Direction: int = 1
var DestroyBulletTimer: Timer

func InitiateProjectile(speed: int, destroyBulletTimer: Timer):
	Speed = speed
	Direction = 1
	DestroyBulletTimer = destroyBulletTimer
	DestroyBulletTimer.connect("timeout", DestroyBulletCuzTimerOut)

func _ready():
	pass

func _process(delta):
	move_local_x(Direction * Speed * delta)
	
func DestroyBulletCuzTimerOut():
	queue_free()
