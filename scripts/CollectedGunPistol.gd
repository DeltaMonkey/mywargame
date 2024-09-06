class_name CollectedGun_Pistol extends BaseGun

#CONSTS
const PROJECTILE_PISTOL = preload("res://scenes/Guns/Projectiles/ProjectilePistol.tscn")

#@ONREADIES
@onready var MuzzleNode = $Muzzle
@onready var ShootCooldownTimerNode = $ShootCooldownTimer

func _ready() -> void:
	InitiateGun(PROJECTILE_PISTOL, MuzzleNode, ShootCooldownTimerNode)

func Shoot(direction: int) -> int:
	return super(direction)
