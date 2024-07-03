class_name CollectedGun_Pistol extends BaseGun

const PROJECTILE_PISTOL = preload("res://scenes/Guns/Projectiles/Projectile_Pistol.tscn")

@onready var MuzzleNode = $Muzzle

func _ready():
	InitiateGun(PROJECTILE_PISTOL, MuzzleNode)
	
