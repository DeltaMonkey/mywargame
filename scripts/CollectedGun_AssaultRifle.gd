extends BaseGun

const PROJECTILE_ASSAULT_RIFLE = preload("res://scenes/Guns/Projectiles/Projectile_AssaultRifle.tscn")
@onready var MuzzleNode = $Muzzle

func _ready():
	ProjectileBase = PROJECTILE_ASSAULT_RIFLE
	Muzzle = MuzzleNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
