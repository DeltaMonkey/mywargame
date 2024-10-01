extends s

#CONSTS
const ROCKET_LAUNCHER_COLLECTED_GUN = preload("res://scenes/Guns/Collected/CollectedGunRocketLauncher.tscn")

func _ready():
	super()
	CollectableGun = ROCKET_LAUNCHER_COLLECTED_GUN
