extends BaseGun

const PROJECTILE_PISTOL = preload("res://scenes/Guns/Projectiles/Projectile_Pistol.tscn")
@onready var MUZZLE = $Muzzle

func _ready():
	projectile_base = PROJECTILE_PISTOL
	muzzle = MUZZLE
	
