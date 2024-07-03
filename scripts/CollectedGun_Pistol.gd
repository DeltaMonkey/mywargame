class_name CollectedGun_Pistol extends BaseGun

const PROJECTILE_PISTOL = preload("res://scenes/Guns/Projectiles/Projectile_Pistol.tscn")

@onready var muzzle_node = $Muzzle
@onready var shoot_cooldown_timer = $ShootCooldownTimer

func _ready():
	InitiateGun(PROJECTILE_PISTOL, muzzle_node, shoot_cooldown_timer)

func Shoot(direction: int) -> int:
	return super(direction)
