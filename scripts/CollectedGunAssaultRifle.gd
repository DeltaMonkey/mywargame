class_name CollectedGun_AssaultRifle extends BaseGun

#CONSTS
const PROJECTILE_ASSAULT_RIFLE = preload("res://scenes/Guns/Projectiles/ProjectileAssaultRifle.tscn")
const BULLET_COUNT: int = 30

#@ONREADIES
@onready var MuzzleNode = $Muzzle
@onready var ShootCooldownTimer = $ShootCooldownTimer

func _ready() -> void:
	InitiateGun(PROJECTILE_ASSAULT_RIFLE, MuzzleNode, ShootCooldownTimer, BULLET_COUNT)

func Shoot(direction: int) -> int:
	return super(direction)
