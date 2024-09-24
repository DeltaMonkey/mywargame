extends BaseCollectableGun

#CONSTS
const SHOT_GUN_COLLECTED_GUN = preload("res://scenes/Guns/Collected/CollectedGunShotGun.tscn")

func _ready():
	super()
	CollectableGun = SHOT_GUN_COLLECTED_GUN
