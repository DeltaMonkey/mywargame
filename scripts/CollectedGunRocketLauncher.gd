class_name CollectedGunRocketLauncher extends BaseGun

#CONSTS
const PROJECTILE_ROCKET_LAUNCHER = preload("res://scenes/Guns/Projectiles/ProjectileRocket.tscn")
const BULLET_COUNT: int = 3

#@ONREADIES
@onready var MuzzleNode = $Muzzle
@onready var ShootCooldownTimer = $ShootCooldownTimer

func _ready() -> void:
	InitiateGun(PROJECTILE_ROCKET_LAUNCHER, MuzzleNode, ShootCooldownTimer, BULLET_COUNT)

func Shoot(direction: int) -> int:
	return super(direction)
