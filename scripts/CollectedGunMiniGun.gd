class_name CollectedGunMiniGun extends BaseGun

#CONSTS
const PROJECTILE_MINI_GUN = preload("res://scenes/Guns/Projectiles/ProjectileMiniGun.tscn")
const BULLET_COUNT: int = 100

#@ONREADIES
@onready var MuzzleNode = $Muzzle
@onready var ShootCooldownTimer = $ShootCooldownTimer

func _ready() -> void:
	InitiateGun(PROJECTILE_MINI_GUN, MuzzleNode, ShootCooldownTimer, BULLET_COUNT)

func Shoot(direction: int) -> int:
	return super(direction)
