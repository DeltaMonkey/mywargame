extends BaseCollectableGun

#CONSTS
const ASSAULT_RIFLE_COLLECTED_GUN = preload("res://scenes/Guns/Collected/CollectedGunAssaultRifle.tscn")

func _ready():
	super()
	CollectableGun = ASSAULT_RIFLE_COLLECTED_GUN
