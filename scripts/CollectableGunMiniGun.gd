extends BaseCollectableGun

#CONSTS
const MINI_GUN_COLLECTED_GUN = preload("res://scenes/Guns/Collected/CollectedGunMiniGun.tscn")

func _ready():
	super()
	CollectableGun = MINI_GUN_COLLECTED_GUN
