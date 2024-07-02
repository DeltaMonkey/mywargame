extends BaseGun

const PROJECTILE_ASSAULT_RIFLE = preload("res://scenes/Guns/Projectiles/Projectile_AssaultRifle.tscn")
@onready var MUZZLE = $Muzzle

func _ready():
	projectile_base = PROJECTILE_ASSAULT_RIFLE
	muzzle = MUZZLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
