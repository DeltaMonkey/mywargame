class_name CollectedGun_AssaultRifle extends BaseGun

const PROJECTILE_ASSAULT_RIFLE = preload("res://scenes/Guns/Projectiles/Projectile_AssaultRifle.tscn")
const BULLET_COUNT: int = 30

@onready var MuzzleNode = $Muzzle

func _ready():
	InitiateGun(PROJECTILE_ASSAULT_RIFLE, MuzzleNode, BULLET_COUNT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
