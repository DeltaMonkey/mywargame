class_name CollectedGun_AssaultRifle extends BaseGun

const PROJECTILE_ASSAULT_RIFLE = preload("res://scenes/Guns/Projectiles/Projectile_AssaultRifle.tscn")
const BULLET_COUNT: int = 30

@onready var muzzle_node = $Muzzle
@onready var shoot_cooldown_timer = $ShootCooldownTimer

func _ready():
	InitiateGun(PROJECTILE_ASSAULT_RIFLE, muzzle_node, shoot_cooldown_timer, BULLET_COUNT)

func Shoot(direction: int) -> int:
	return super(direction)
