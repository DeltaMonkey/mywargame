class_name CollectedGunShotGun extends BaseGun

#CONSTS
const PROJECTILE_SHOT_GUN = preload("res://scenes/Guns/Projectiles/ProjectileShotGun.tscn")
const BULLET_COUNT: int = 7

#@ONREADIES
@onready var MuzzleNode = $Muzzle
@onready var ShootCooldownTimer = $ShootCooldownTimer

func _ready() -> void:
	InitiateGun(PROJECTILE_SHOT_GUN, MuzzleNode, ShootCooldownTimer, BULLET_COUNT)

func Shoot(direction: int) -> int:
	return super(direction)
